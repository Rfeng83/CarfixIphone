//
//  MobileUserAPI.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class MobileUserAPI: BaseAPIPost
{
    override func getWebBaseURL() -> String {
        return "\(super.getWebBaseURL())/Carfix"
    }
    
    override func isJSONContentType() -> Bool {
        return true
    }
    
    func getToken() -> String {
        return CarfixInfo().profile.loginToken ?? ""
    }
    
    override func post<T : MobileUserAPIResponse>(method: String, parameters: [String : Any]?, onSuccess: @escaping (T?) -> Void) {
        
        let captureOnSuccess: (T?) -> Void = { data in
            if let data = data {
                if data.Succeed == true {
                    onSuccess(data)
                } else if data.Message == "Authorization has been denied for this request." {
                    self.genToken() { data in
                        if data?.Succeed == true {
                            let db = CarfixInfo()
                            let profile = db.profile
                            profile.loginToken = data?.Result?.token
                            db.save()
                            self.post(method: method, parameters: parameters, onSuccess: onSuccess)
                        }
                    }
                } else {
                    if CarfixInfo().profile.loginID == "60122538125" {
                        self.viewController.message(content: data.Message ?? "Error message not available")
                    } else {
                        self.viewController.message(content: "Server internal error.")
                    }
                }
            }
        }
        
        super.post(method: method, parameters: parameters, onBuildRequest: { req in
            var request = req
            request.setValue("Bearer \(self.getToken())", forHTTPHeaderField: "Authorization")
            return request
        }, onSuccess: captureOnSuccess)
    }
    
    func genToken(onSuccess: @escaping (GenTokenResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue("alexis@carfix.my", forKey: "PhoneNo")
        parameters.updateValue("123456", forKey: "Secret")
        super.post(method: "api/Token/GenToken", parameters: parameters, onBuildRequest: { req in return nil }, onSuccess: onSuccess)
    }
    
    func getMakeItems(year: Int, onSuccess: @escaping (GetSelectListItemsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(year, forKey: "year")
        post(method: "api/CarInfo/GetMakeItems", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getModelItems(year: Int, make: String, onSuccess: @escaping (GetSelectListItemsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(year, forKey: "year")
        parameters.updateValue(make, forKey: "make")
        post(method: "api/CarInfo/GetModelItems", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getEngineCCItems(year: Int, make: String, model: String, onSuccess: @escaping (GetSelectListItemsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(year, forKey: "year")
        parameters.updateValue(make, forKey: "make")
        parameters.updateValue(model, forKey: "model")
        post(method: "api/CarInfo/GetEngineCCItems", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getTransmissionItems(year: Int, make: String, model: String, cc: String, onSuccess: @escaping (GetSelectListItemsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(year, forKey: "year")
        parameters.updateValue(make, forKey: "make")
        parameters.updateValue(model, forKey: "model")
        parameters.updateValue(cc, forKey: "cc")
        post(method: "api/CarInfo/GetTransmissionItems", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getVariantSeriesItems(year: Int, make: String, model: String, cc: String, trmsn: String, onSuccess: @escaping (GetSelectListItemsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(year, forKey: "year")
        parameters.updateValue(make, forKey: "make")
        parameters.updateValue(model, forKey: "model")
        parameters.updateValue(cc, forKey: "cc")
        parameters.updateValue(trmsn, forKey: "trmsn")
        post(method: "api/CarInfo/GetVariantSeriesItems", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getVehicles(year: Int, make: String, model: String, cc: String, trmsn: String, varser: String, onSuccess: @escaping (GetVehicleNVICResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(year, forKey: "year")
        parameters.updateValue(make, forKey: "make")
        parameters.updateValue(model, forKey: "model")
        parameters.updateValue(cc, forKey: "cc")
        parameters.updateValue(trmsn, forKey: "trmsn")
        parameters.updateValue(varser, forKey: "varser")
        post(method: "api/CarInfo/GetVehicles", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getOfferServices(vehicleID: String, onSuccess: @escaping (GetOfferServicesResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(vehicleID, forKey: "vehicleID")
        post(method: "api/VehicleInfo/GetOfferServices", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getServiceOffer(serviceID: Int, vehicleID: String, onSuccess: @escaping (GetOfferServicesResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(serviceID, forKey: "serviceID")
        parameters.updateValue(vehicleID, forKey: "vehicleID")
        post(method: "api/VehicleInfo/GetServiceOffer", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateServiceOffers(vehicleID: String, onSuccess: @escaping (MobileUserAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(vehicleID, forKey: "vehicleID")
        post(method: "api/VehicleInfo/UpdateServiceOffers", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getHistoryCases(phoneNo: String, onSuccess: @escaping (GetHistoryCasesResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(phoneNo, forKey: "PhoneNo")
        post(method: "api/UserInfo/GetHistoryCases", parameters: parameters, onSuccess: onSuccess)
    }
    
    func changePassword(oldPassword: String, newPassword: String, confirmPassword: String, phoneNo: String, onSuccess: @escaping (MobileUserAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(oldPassword, forKey: "OldPassword")
        parameters.updateValue(newPassword, forKey: "NewPassword")
        parameters.updateValue(confirmPassword, forKey: "ConfirmPassword")
        parameters.updateValue(phoneNo, forKey: "PhoneNo")
        post(method: "api/UserInfo/ChangePassword", parameters: parameters, onSuccess: onSuccess)
    }
    
}
