//
//  CarFixAPIPost.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CarFixAPIPost: BaseAPIPost
{
    override func getWebBaseURL() -> String {
        return "\(super.getWebBaseURL())/Core/Mobile"
    }
    
    private func getUID() -> String {
        let profile = CarfixInfo().profile
        let uid: String = "\(profile.password!);\(profile.loginID!)"
        return uid
    }
    
    override func post<T : BaseAPIResponse>(method: String, parameters: [String : Any]?, onSuccess: @escaping (T?) -> Void) {
        super.post(method: method, parameters: parameters, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            //request.setValue(self.mInsCode, forHTTPHeaderField: "InsCode")
            return request
        }, onSuccess: onSuccess)
    }
    
    func phoneRegisteration(email: String, name:String, country:Int, isIOS: Int32, onSuccess: @escaping (PhoneRegistrationResponse?) -> Void)
    {
        var parameters = [String: Any]()
        parameters.updateValue(email, forKey: "email")
        parameters.updateValue(name, forKey: "name")
        parameters.updateValue(country, forKey: "country")
        parameters.updateValue(isIOS, forKey: "isIOS")
        self.post(method: "PhoneRegisteration", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getProfile(onSuccess: @escaping (GetProfileResponse?) -> Void) {
        self.post(method: "GetProfile", parameters: nil, onSuccess: onSuccess)
    }
    
    func updateFirebase(token: String, isIOS: Int32, onSuccess: @escaping (CarFixAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(token, forKey: "token")
        parameters.updateValue(isIOS, forKey: "isIOS")
        self.post(method: "UpdateFirebase", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateProfile(name: String, email: String, onSuccess: @escaping (CarFixAPIResponse?) -> Void)
    {
        var parameters = [String: Any]()
        parameters.updateValue(name, forKey: "name")
        parameters.updateValue(email, forKey: "email")
        self.post(method: "UpdateProfile", parameters: parameters, onSuccess: onSuccess)
    }
    
    func verifyActivationCode(onSuccess: @escaping (CarFixAPIResponse?) -> Void) {
        self.post(method: "VerifyActivationCode", parameters: nil, onSuccess: onSuccess)
    }
    
    func getVehicles(key: String?, onSuccess: @escaping (GetVehiclesResponse?) -> Void) {
        onGetStart()
        var parameters = [String: Any]()
        if let key = key {
            parameters.updateValue(key, forKey: "key")
        }
        self.post(method: "GetVehicles", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateVehicle(key: String?, vehicleRegNo: String, brand: String?, model: String, year: Int32?, cc: String?, trmsn: String?, varser: String?, nvic: String?, isDefault: Int32, policyEffDate: Date?, policyExpDate: Date?, onSuccess: @escaping (KeyResponse?) -> Void)
    {
        var parameters = [String: Any]()
        if let key = key {
            parameters.updateValue(key, forKey: "key")
        }
        parameters.updateValue(vehicleRegNo, forKey: "vehicleRegNo")
        if let brand = brand {
            parameters.updateValue(brand, forKey: "brand")
        }
        parameters.updateValue(model, forKey: "model")
        if let year = year {
            parameters.updateValue(year, forKey: "year")
        }
        if let cc = cc {
            parameters.updateValue(cc, forKey: "engineCC")
        }
        if let trmsn = trmsn {
            parameters.updateValue(trmsn, forKey: "transmission")
        }
        if let varser = varser {
            parameters.updateValue(varser, forKey: "variant")
        }
        if let nvic = nvic {
            parameters.updateValue(nvic, forKey: "nvic")
        }
        parameters.updateValue(isDefault, forKey: "isDefault")
        if let policyEffDate = policyEffDate {
            parameters.updateValue(policyEffDate, forKey: "policyEffDate")
        }
        if let policyExpDate = policyExpDate {
            parameters.updateValue(policyExpDate, forKey: "policyExpDate")
        }
        
        self.post(method: "UpdateVehicle", parameters: parameters, onSuccess: onSuccess)
    }
    
    func setDefaultVehicle(key: String, onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "SetDefaultVehicle", parameters: parameters, onSuccess: onSuccess)
    }
    
    func deleteVehicle(key: String, onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "DeleteVehicle", parameters: parameters, onSuccess: onSuccess)
    }
    
    func logCase(vehReg: String, serviceNeeded: Int16, address: String, latitude: Double, longitude: Double, vehModel: String, policyID: Int32, onSuccess: @escaping (LogCaseResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(vehReg, forKey: "vehReg")
        parameters.updateValue(serviceNeeded, forKey: "serviceNeeded")
        parameters.updateValue(address, forKey: "address")
        parameters.updateValue(latitude, forKey: "latitude")
        parameters.updateValue(longitude, forKey: "longitude")
        parameters.updateValue(vehModel, forKey: "vehModel")
        parameters.updateValue(policyID, forKey: "policyID")
        
        self.post(method: "LogCase", parameters: parameters, onSuccess: onSuccess)
    }
    
    func newClaim(ins: String, vehReg: String, accidentDate: Date, icNo: String, workshop: String?,latitude: Double, longitude: Double, accidentLocation: String, images: [String: UIImage], onSuccess: @escaping (NewClaimResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(ins, forKey: "ins")
        parameters.updateValue(vehReg, forKey: "vehReg")
        parameters.updateValue(accidentDate, forKey: "accidentDate")
        parameters.updateValue(icNo, forKey: "icNo")
        if let val = workshop { parameters.updateValue(val, forKey: "workshop") }
        parameters.updateValue(latitude, forKey: "latitude")
        parameters.updateValue(longitude, forKey: "longitude")
        parameters.updateValue(accidentLocation, forKey: "accidentLocation")
        postFile(method: "NewClaim", parameters: parameters, images: images, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            return request
        }, onSuccess: onSuccess)
    }
    
    func getClaim(key: String, onSuccess: @escaping (GetClaimResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaim", parameters: parameters, onSuccess: onSuccess)
    }
    
    func uploadClaimPhotos(key: String, images: [String: UIImage], onSuccess: @escaping (NewClaimResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        postFile(method: "UploadClaimPhotos", parameters: parameters, images: images, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            return request
        }, onSuccess: onSuccess)
    }
    
    func getCaseHistory(onSuccess: @escaping (GetCaseHistoryResponse?) -> Void) {
        self.post(method: "GetCaseHistory", parameters: nil, onSuccess: onSuccess)
    }
    
    func getCaseDetails(key: String, onSuccess: @escaping (GetCaseDetailsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetCaseDetails", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getNotification(onSuccess: @escaping (GetNotificationResponse?) -> Void) {
        self.post(method: "GetNotification", parameters: nil, onSuccess: onSuccess)
    }
    
    func getBrands(onSuccess: @escaping (GetBrandsResponse?) -> Void) {
        self.post(method: "GetBrands", parameters: nil, onSuccess: onSuccess)
    }
    
    func getNewsFeed(category: Int32?, year: Int32?, month: Int32?, onSuccess: @escaping (GetNewsFeedResponse?) -> Void) {
        var parameters = [String: Any]()
        if let val = category { parameters.updateValue(val, forKey: "category") }
        if let val = year { parameters.updateValue(val, forKey: "year") }
        if let val = month { parameters.updateValue(val, forKey: "month") }
        self.post(method: "GetNewsFeed", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getMobileNewsFeedCategory(onSuccess: @escaping (GetMobileNewsFeedCategoriesResponse?) -> Void) {
        self.post(method: "GetMobileNewsFeedCategories", parameters: nil, onSuccess: onSuccess)
    }
    
    func generalHelps(onSuccess: @escaping (GeneralHelpsResponse?) -> Void) {
        self.post(method: "GeneralHelps", parameters: nil, onSuccess: onSuccess)
    }
    
    func getLocationAreas(onSuccess: @escaping (GetLocationAreasResponse?) -> Void) {
        self.post(method: "GetLocationAreas", parameters: nil, onSuccess: onSuccess)
    }
    
    func getPanelWorkshops(ins: String, area: Int32, onSuccess: @escaping (GetPanelWorkshopsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(ins, forKey: "ins")
        parameters.updateValue(area, forKey: "area")
        self.post(method: "GetPanelWorkshops", parameters: parameters, onSuccess: onSuccess)
    }
    
    func uploadImages(folder: String, key: String?, images: [String: UIImage], onSuccess: @escaping (UploadResponse?) -> Void)
    {
        var parameters = [String: Any]()
        parameters.updateValue(folder, forKey: "folder")
        if let val = key {
            parameters.updateValue(val, forKey: "key")
        }
        postFile(method: "UploadImages", parameters: parameters, images: images, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            //            request.setValue(self.mInsCode, forHTTPHeaderField: "InsCode")
            return request
        }, onSuccess: onSuccess)
    }   
    
}
