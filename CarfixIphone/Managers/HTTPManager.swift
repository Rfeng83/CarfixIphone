//
//  HttpManager.swift
//  Carfix
//
//  Created by Re Foong Lim on 20/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
import UIKit

public class BaseHTTPManager
{
    public static func getData(from: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void ) {
        let session = URLSession.shared
        
        var request = URLRequest(url: from)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard error == nil else {
                print(error ?? "")
                return
            }
            guard data != nil else {
                print("Data is empty")
                return
            }
            
            completion(data, response, error)
        }
        
        task.resume()
    }
    
    public static func loadImageFromUrl(mUrl: String, imageView: UIImageView){
        if let url = URL(string: mUrl) {
            getData(from: url) { (data, response, error)  in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else { return }
                    if let fileName = response?.suggestedFilename {
                        print("\(fileName) Download Finished")
                    }
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

class HTTPManager<T: BaseAPIResponse> {
    public static func post(with: URL, byJSON: Bool, parameters: [String: Any]?, onBuildRequest: @escaping (URLRequest) -> URLRequest?, onSuccess: @escaping (T?) -> Void, onError: @escaping (Error) -> Void) {
        let session = URLSession.shared
        
        var request = URLRequest(url: with)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        
        request = onBuildRequest(request) ?? request
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if byJSON {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = getJSONBodyContent(parameters: parameters)
        } else {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = getBodyContent(parameters: parameters)
        }
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard error == nil else {
                onError(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            DispatchQueue.main.async(execute: {
                onSuccess(T(json: json))
            })
        }
        
        task.resume()
    }
    
    public static func getBodyContent(parameters: [String: Any]?) -> Data? {
        var firstOneAdded = false
        var contentBodyAsString = String()
        if parameters != nil {
            for (key, value) in parameters! {
                if !(value is NSNull) {
                    let string: String = Convert(value).to()!
                    if (!firstOneAdded) {
                        contentBodyAsString = contentBodyAsString + key + "=" + string
                        firstOneAdded = true
                    }
                    else {
                        contentBodyAsString = contentBodyAsString + "&" + key + "=" + string
                    }
                }
            }
        }
        contentBodyAsString = contentBodyAsString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return contentBodyAsString.data(using: String.Encoding.utf8)
    }
    
    public static func getJSONBodyContent(parameters: [String: Any]?) -> Data? {
        var firstOneAdded = false
        var contentBodyAsString = String()
        contentBodyAsString = "{"
        if parameters != nil {
            for (key, value) in parameters! {
                if !(value is NSNull) {
                    var string: String = Convert(value).to()!
                    if type(of: value) == String.self {
                        string = "'\(string.replacingOccurrences(of: "'", with: "\\'"))'"
                    }
                    
                    if (!firstOneAdded) {
                        contentBodyAsString = contentBodyAsString + key + ":" + string
                        firstOneAdded = true
                    }
                    else {
                        contentBodyAsString = contentBodyAsString + "," + key + ":" + string
                    }
                }
            }
        }
        contentBodyAsString = contentBodyAsString + "}"
        
        return contentBodyAsString.data(using: String.Encoding.utf8)
    }
    
    public static func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    public static func postFile(with: URL, parameters: [String: Any]?, images: [String: UIImage], onBuildRequest: @escaping (URLRequest) -> URLRequest, onSuccess: @escaping (T?) -> Void, onError: @escaping (Error) -> Void)
    {
        let session = URLSession.shared
        
        var request = URLRequest(url: with)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        
        request = onBuildRequest(request)
        
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        //define the data post parameter
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(String(describing: value))\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        var count = 0
        for (fileName, image) in images {
            let image_data = image.compressedData
            
            if image_data == nil {
                continue
            }
            
            let ext = URL(fileURLWithPath: fileName).pathExtension.lowercased()
            let mimetype = "image/\(ext)"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            
            let name = images.count > 1 ? "images[\(count)]" : "images"
            let content = "Content-Disposition:form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!
            body.append(content)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image_data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            count = count + 1            
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                onError(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        DispatchQueue.main.async(execute: {
                            onSuccess(T(json: json))
                        })
                    } catch let JSONError as NSError {
                        print(JSONError)
                    }
                } else {
                    onError(MyError.InternetError("\(httpResponse.statusCode) Error Occured..."))
                }
            } else {
                onError(MyError.MismatchResposeError("Can't cast response to NSHTTPURLResponse"))
            }
        }
        
        task.resume()
    }
}
