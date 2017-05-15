//
//  BaseAPIPost.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BaseAPIPost
{
    func getWebBaseURL() -> String {
        //let carFix = CarFixInfo()
        //let setting = carFix.setting
        
        //        if(setting.countryCode == Country.ph.rawValue){
        //            return RootPath.Ph.rawValue
        //        }
        return RootPath.My.rawValue
    }
    
    func getAPIBaseURL() -> String {
        return "\(getWebBaseURL())/\(type(of: self))/";
    }
    
    func getAPIMethodUrl(method: String) -> URL {
        return URL(string: getAPIBaseURL() + method)!
    }
    
    func isJSONContentType() -> Bool {
        return false
    }
    
    var viewController: UIViewController
    var isShowProgressBar: Bool
    
    required init(_ viewController: UIViewController, progressBar: Bool) {
        self.viewController = viewController
        self.isShowProgressBar = progressBar
    }
    
    convenience init(_ viewController: UIViewController) {
        self.init(viewController, progressBar: true)
    }
    
    func onClientError(error: Error) {
        if self.onGetEnd(response: nil) {
            self.viewController.alert(content: "Connection error")
        }
    }
    func onGetStart(){
        if isShowProgressBar {
            self.viewController.showProgressBar()
        }
    }
    func onGetEnd(response: BaseAPIResponse?) -> Bool {
        self.viewController.hideProgressBar()
        
        if let data = response as? CarFixAPIResponse {
            if data.Code != 100 {
                self.viewController.alert(content: data.Message!)
                return false
            }
        }
        
        return true
    }
    
    func post<T: BaseAPIResponse>(method: String, parameters: [String: Any]?, onSuccess: @escaping (T?) -> Void) {
        post(method: method, parameters: parameters, onBuildRequest: { data in return nil }, onSuccess: onSuccess)
    }
    func post<T: BaseAPIResponse>(method: String, parameters: [String: Any]?, onBuildRequest: @escaping (URLRequest) -> URLRequest?, onSuccess: @escaping (T?) -> Void) {
        onGetStart()
        let url = getAPIMethodUrl(method: method)
        HTTPManager<T>.post(with: url, byJSON: isJSONContentType(), parameters: parameters, onBuildRequest: onBuildRequest, onSuccess: { data in
            if self.onGetEnd(response: data) {
                onSuccess(data)
            }
        }, onError: { data in
            self.onClientError(error: data)
        })
    }
    
    func postFile<T: BaseAPIResponse>(method: String, parameters: [String: Any]?, images: [String: UIImage], onBuildRequest: @escaping (URLRequest) -> URLRequest, onSuccess: @escaping (T?) -> Void) {
        onGetStart()
        let url = getAPIMethodUrl(method: method)
        HTTPManager<T>.postFile(with: url, parameters: parameters, images: images, onBuildRequest: onBuildRequest, onSuccess: { data in
            if self.onGetEnd(response: data) {
                onSuccess(data)
            }
        }, onError: { data in
            self.onClientError(error: data)
        })
    }
}
