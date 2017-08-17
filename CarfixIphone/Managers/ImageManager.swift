//
//  ImageManager.swift
//  Carfix2
//
//  Created by Re Foong Lim on 06/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

class ImageManager
{
    static func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    static func fileInDocumentsDirectory(filename: String?) -> URL? {
        if filename.isEmpty {
            return nil
        }
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename!)
        return fileURL
        
    }
    
    static func loadImageFromPath(path: String?) -> UIImage? {
        if path == nil {
            return nil
        }
        
        let image = UIImage(contentsOfFile: path!)
        
        if image == nil {
            print("missing image at: \(path!)")
        } else {
            print("Loading image from path: \(path!)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        }
        return image
        
    }
    
    static var imageCache: [String : UIImage] = [:]
    static func downloadImage(mUrl: String, imageView: UIImageView) {
        downloadImage(mUrl: mUrl, imageView: imageView, cache: true) { data in
            
        }
    }
    static func downloadImage(mUrl: String, imageView: UIImageView, cache: Bool) {
        downloadImage(mUrl: mUrl, imageView: imageView, cache: cache) { data in
            
        }
    }
    
    //    static func clearCache(url: String) {
    //        if imageCache.contains(where: { (key, data) in
    //            return key == url }) {
    //            imageCache.removeValue(forKey: url)
    //        }
    //    }
    
    static func downloadImage(mUrl: String, imageView: UIImageView, onSuccess: @escaping (UIImageView) -> Void) {
        downloadImage(mUrl: mUrl, imageView: imageView, cache: false, onSuccess: onSuccess)
    }
//    
//    static func downloadImage(mUrl: String, imageView: UIImageView, cache: Bool, onSuccess: @escaping (UIImageView) -> Void) {
//        let oriSize = imageView.frame.size
//        let oriImage = imageView.image
//        if oriImage.isEmpty {
//            imageView.image = #imageLiteral(resourceName: "loading")
//        }
//        
//        let cachedImage = imageCache[mUrl]
//        if !cache || cachedImage.isEmpty {
//            if let url = URL(string: mUrl) {
//                print("Download Started")
//                print("lastPathComponent: " + (url.lastPathComponent ))
//                
//                URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: cache ? .useProtocolCachePolicy : .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)) { (data, response, error) in
//                    DispatchQueue.main.async { () -> Void in
//                        guard let data = data, error == nil else { return }
//                        print(response?.suggestedFilename ?? "")
//                        print("Download Finished")
//                        if let image = UIImage(data: data) {
//                            imageViewSetImage(imageView: imageView, cachedImage: image, size: oriSize)
//                            ImageManager.imageCache[mUrl] = image
//                        } else {
//                            imageView.image = oriImage
//                            ImageManager.imageCache[mUrl] = oriImage
//                        }
//                        onSuccess(imageView)
//                    }
//                    }.resume()
//            }
//        }
//        else {
//            imageViewSetImage(imageView: imageView, cachedImage: cachedImage, size: oriSize)
//            onSuccess(imageView)
//        }
//    }
    
    static func downloadImage(mUrl: String, imageView: UIImageView, cache: Bool, onSuccess: @escaping (UIImageView) -> Void) {
        let oriImage = imageView.image
        var loadingImage = oriImage
        if loadingImage.isEmpty {
            loadingImage = #imageLiteral(resourceName: "loading")
        }
        imageViewSetImage(imageView: imageView, cachedImage: loadingImage)
        
        if let image = imageView as? CustomImageView {
            image.path = mUrl
        }
        downloadImage(mUrl: mUrl, cache: cache) { data in
            if let image = data {
                imageViewSetImage(imageView: imageView, cachedImage: image)
            } else {
                imageView.image = oriImage
                ImageManager.imageCache[mUrl] = oriImage
            }
        }
    }

    static func downloadImage(mUrl: String, cache: Bool, onSuccess: @escaping (UIImage?) -> Void) {
        let cachedImage = imageCache[mUrl]
        if !cache || cachedImage.isEmpty {
            if let url = URL(string: mUrl) {
                print("Download Started")
                print("lastPathComponent: " + (url.lastPathComponent ))
                
                URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: cache ? .useProtocolCachePolicy : .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)) { (data, response, error) in
                    DispatchQueue.main.async { () -> Void in
                        guard let data = data, error == nil else { return }
                        print(response?.suggestedFilename ?? "")
                        print("Download Finished")
                        if let image = UIImage(data: data) {
                            ImageManager.imageCache[mUrl] = image
                            onSuccess(image)
                        } else {
                            onSuccess(nil)
                        }
                    }
                    }.resume()
            }
        }
        else {
            onSuccess(cachedImage)
        }
    }
    
    static func imageViewSetImage(imageView: UIImageView, cachedImage: UIImage?) {
        let width = imageView.frame.width
        let height = imageView.frame.height
        
        if let image = cachedImage {
            if width > 0 && height <= 0 {
                imageView.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: width, height: width / image.size.width * image.size.height))
            }
            else if height > 0 && width <= 0 {
                imageView.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: height / image.size.height * width, height: height))
            }
            else if height <= 0 && width <= 0 {
                imageView.frame = CGRect(origin: imageView.frame.origin, size: image.size)
            }
//            else {
//                imageView.frame = CGRect(origin: imageView.frame.origin, size: size!)
//            }
        }
        
        imageView.image = cachedImage
        
    }
    
    static func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(image: RBSquareImage(image: image), targetSize: size)
    }
    
    static func RBSquareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        let imageRef = image.cgImage!.cropping(to: cropSquare);
        
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    
    static func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func saveImage (image: UIImage, path: String) -> Bool{
        
        //let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 0.2)   // if you want to save as JPEG
        if let url = URL(string: path) {
            do {
                try jpgImageData?.write(to: url, options: .atomic)//(path, atomically: true)
                return true
            } catch {
                print(error)
            }
        }
        
        return false
    }
    
    static func deleteImage(path: String) -> Bool{
        if path.isEmpty == false {
            let fileManager = FileManager.default
            do {
                if let imagePath = fileInDocumentsDirectory(filename: path) {
                    try fileManager.removeItem(atPath: imagePath.path)
                }
            } catch {
                print("Could not delete image: \(error)")
                return false
            }
        }
        return true
    }
    
}
