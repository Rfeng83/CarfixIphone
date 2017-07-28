//
//  CarFixAPIPost.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore

class CarFixAPIPost: BaseAPIPost
{
    override func getWebBaseURL() -> String {
        return "\(super.getWebBaseURL())/Core/Mobile"
    }
    
    private func getUID() -> String {
        let profile = CarfixInfo().profile
        if profile.password.hasValue && profile.loginID.hasValue {
            let uid: String = "\(profile.password!);\(profile.loginID!)"
            return uid
        } else {
            return ""
        }
    }
    
    private func getFID() -> String? {
        if let token = AccessToken.current?.userId {
            return token
        }
        return nil
    }
    
    override func post<T : BaseAPIResponse>(method: String, parameters: [String : Any]?, onSuccess: @escaping (T?) -> Void) {
        super.post(method: method, parameters: parameters, onBuildRequest: { req in
            var request = req
            if let fid = self.getFID() {
                request.setValue(fid, forHTTPHeaderField: "FID")
            } else {
                request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            }
            //request.setValue(self.mInsCode, forHTTPHeaderField: "InsCode")
            return request
        }, onSuccess: onSuccess)
    }
    
    func checkUser(onSuccess: @escaping (CheckUserResponse?) -> Void) {
        self.post(method: "CheckUser", parameters: nil, onSuccess: onSuccess)
    }
    
    func checkVersion(ver: String, onSuccess: @escaping (CheckVersionResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(ver, forKey: "ver")
        self.post(method: "CheckVersion", parameters: parameters, onSuccess: onSuccess)
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
    
    func updateFirebase(token: String, isIOS: Bool, onSuccess: @escaping (CarFixAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(token, forKey: "token")
        parameters.updateValue(isIOS, forKey: "isIOS")
        self.post(method: "UpdateFirebase", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateFacebook(name: String, email: String, onSuccess: @escaping (CarFixAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(name, forKey: "name")
        parameters.updateValue(email, forKey: "email")
        self.post(method: "UpdateFacebook", parameters: parameters, onSuccess: onSuccess)
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
        postFile(method: "NewClaim", parameters: parameters, images: images, onSuccess: onSuccess)
    }
    
    func getClaim(key: String, onSuccess: @escaping (GetClaimResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaim", parameters: parameters, onSuccess: onSuccess)
    }
    
    func submitClaimReply(key: String, replyMessage: String?, onSuccess: @escaping (SubmitClaimReplyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        if let val = replyMessage { parameters.updateValue(val, forKey: "replyMessage") }
        self.post(method: "SubmitClaimReply", parameters: parameters, onSuccess: onSuccess)
    }


    func newPendingClaim(vehReg: String, claimTypeID: Int32, isDriver: Int16, insurerName: String, onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(vehReg, forKey: "vehReg")
        parameters.updateValue(claimTypeID, forKey: "claimTypeID")
        parameters.updateValue(isDriver, forKey: "isDriver")
        parameters.updateValue(insurerName, forKey: "insurerName")
        self.post(method: "NewPendingClaim", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getClaimPersonalDetails(key: String, onSuccess: @escaping (GetClaimPersonalDetailsResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaimPersonalDetails", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateClaimPersonalDetails(key: String, OwnerName: String?, OwnerIC: String?, OwnerTel: String?, OwnerMobile: String?, OwnerEmail: String?, OwnerGstNo: String?, isBusiness: Bool?, isDriverTheOwner: Bool?, DriverName: String?, DriverIC: String?, DriverTel: String?, DriverMobile: String?, LicenceType: String?, LicenceClass: String?, LicenceExpiredOn: Date?, LicenceIssuedOn: Date?, LicenceSuspended: Bool?, onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        if let val = OwnerName { parameters.updateValue(val, forKey: "OwnerName") }
        if let val = OwnerIC { parameters.updateValue(val, forKey: "OwnerIC") }
        if let val = OwnerTel { parameters.updateValue(val, forKey: "OwnerTel") }
        if let val = OwnerMobile { parameters.updateValue(val, forKey: "OwnerMobile") }
        if let val = OwnerEmail { parameters.updateValue(val, forKey: "OwnerEmail") }
        if let val = OwnerGstNo { parameters.updateValue(val, forKey: "OwnerGstNo") }
        if let val = isBusiness { parameters.updateValue(val, forKey: "isBusiness") }
        if let val = isDriverTheOwner { parameters.updateValue(val, forKey: "isDriverTheOwner") }
        if let val = DriverName { parameters.updateValue(val, forKey: "DriverName") }
        if let val = DriverIC { parameters.updateValue(val, forKey: "DriverIC") }
        if let val = DriverTel { parameters.updateValue(val, forKey: "DriverTel") }
        if let val = DriverMobile { parameters.updateValue(val, forKey: "DriverMobile") }
        if let val = LicenceType { parameters.updateValue(val, forKey: "LicenceType") }
        if let val = LicenceClass { parameters.updateValue(val, forKey: "LicenceClass") }
        if let val = LicenceExpiredOn { parameters.updateValue(val, forKey: "LicenceExpiredOn") }
        if let val = LicenceIssuedOn { parameters.updateValue(val, forKey: "LicenceIssuedOn") }
        if let val = LicenceSuspended { parameters.updateValue(val, forKey: "LicenceSuspended") }
        self.post(method: "UpdateClaimPersonalDetails", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateClaimVehicle(key: String, engineNo: String?, chassisNo: String?, dateOfAcc: Date?, placeOfAcc: String?, policeReportNo: String?, isInsuredConsent: Bool?, vehiclePurpose: String?, roadSide: String?, accLatitude: Double?, accLongitude: Double?, onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        if let engineNo = engineNo { parameters.updateValue(engineNo, forKey: "engineNo") }
        if let chassisNo = chassisNo { parameters.updateValue(chassisNo, forKey: "chassisNo") }
        if let dateOfAcc = dateOfAcc { parameters.updateValue(dateOfAcc, forKey: "dateOfAcc") }
        if let placeOfAcc = placeOfAcc { parameters.updateValue(placeOfAcc, forKey: "placeOfAcc") }
        if let policeReportNo = policeReportNo { parameters.updateValue(policeReportNo, forKey: "policeReportNo") }
        if let isInsuredConsent = isInsuredConsent { parameters.updateValue(isInsuredConsent, forKey: "isInsuredConsent") }
        if let vehiclePurpose = vehiclePurpose { parameters.updateValue(vehiclePurpose, forKey: "vehiclePurpose") }
        if let roadSide = roadSide { parameters.updateValue(roadSide, forKey: "roadSide") }
        if let accLatitude = accLatitude { parameters.updateValue(accLatitude, forKey: "accLatitude") }
        if let accLongitude = accLongitude { parameters.updateValue(accLongitude, forKey: "accLongitude") }
        
        self.post(method: "UpdateClaimVehicle", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getClaimVehicle(key: String, onSuccess: @escaping (GetClaimVehicleResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaimVehicle", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateClaimEPayment(key: String, bankName: String?, accountName: String?, accountNumber: String?, bankAddress: String?, images: [String: UIImage], onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        if let val = bankName { parameters.updateValue(val, forKey: "bankName") }
        if let val = accountName { parameters.updateValue(val, forKey: "accountName") }
        if let val = accountNumber { parameters.updateValue(val, forKey: "accountNumber") }
        if let val = bankAddress { parameters.updateValue(val, forKey: "bankAddress") }
        self.postFile(method: "UpdateClaimEPayment", parameters: parameters, images: images, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            return request
        }, onSuccess: onSuccess)
    }
    
    func getClaimEPayment(key: String, onSuccess: @escaping (GetClaimEPaymentResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaimEPayment", parameters: parameters, onSuccess: onSuccess)
    }
    
    func updateClaimWorkshop(key: String, workshop: String?, onSuccess: @escaping (CarFixAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        if let val = workshop { parameters.updateValue(val, forKey: "workshop") }
        self.post(method: "UpdateClaimWorkshop", parameters: parameters, onSuccess: onSuccess)
    }

    func getClaimWorkshop(key: String, onSuccess: @escaping (GetClaimWorkshopResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaimWorkshop", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getClaimContentCategories(key: String, onSuccess: @escaping (GetClaimContentCategoriesResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaimContentCategories", parameters: parameters, onSuccess: onSuccess)
    }
    
    func getClaimDocumentsInPdf(key: String, onSuccess: @escaping (GetClaimDocumentsInPdfResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "GetClaimDocumentsInPdf", parameters: parameters, onSuccess: onSuccess)
    }
    
    func uploadClaimPhotos(key: String, claimMessageId: Int32?, images: [String: UIImage], onSuccess: @escaping (NewClaimResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        if let claimMessageId = claimMessageId {
            parameters.updateValue(claimMessageId, forKey: "claimMessageId")
        }
        postFile(method: "UploadClaimPhotos", parameters: parameters, images: images, onSuccess: onSuccess)
    }
    
    func submitSignedClaim(key: String, images: [String: UIImage], onSuccess: @escaping (SubmitSignedClaimResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        postFile(method: "SubmitSignedClaim", parameters: parameters, images: images, onSuccess: onSuccess)
    }
    
    func submitSignedDV(key: String, witnessName: String, witnessIC: String, images: [String: UIImage], onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        parameters.updateValue(witnessName, forKey: "witnessName")
        parameters.updateValue(witnessIC, forKey: "witnessIC")
        postFile(method: "SubmitSignedDV", parameters: parameters, images: images, onSuccess: onSuccess)
    }
    
    func deleteClaim(key: String, onSuccess: @escaping (CarFixAPIResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "DeleteClaim", parameters: parameters, onSuccess: onSuccess)
    }
    
    func cancelClaim(key: String, onSuccess: @escaping (KeyResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(key, forKey: "key")
        self.post(method: "CancelClaim", parameters: parameters, onSuccess: onSuccess)
    }

    func getCaseHistory(onSuccess: @escaping (GetCaseHistoryResponse?) -> Void) {
        self.post(method: "GetCaseHistory", parameters: nil, onSuccess: onSuccess)
    }
    
    func getResolvedCases(onSuccess: @escaping (GetResolvedCasesResponse?) -> Void) {
        post(method: "GetResolvedCases", parameters: nil, onSuccess: onSuccess)
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
    
    func uploadImages(folder: String, key: String?, images: [String: UIImage], onSuccess: @escaping (UploadResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(folder, forKey: "folder")
        if let val = key {
            parameters.updateValue(val, forKey: "key")
        }
        postFile(method: "UploadImages", parameters: parameters, images: images, onSuccess: onSuccess)
    }
    
    func postFile<T>(method: String, parameters: [String : Any]?, images: [String : UIImage], onSuccess: @escaping (T?) -> Void) where T : BaseAPIResponse {
        postFile(method: method, parameters: parameters, images: images, onBuildRequest: { req in
            var request = req
            if let fid = self.getFID() {
                request.setValue(fid, forHTTPHeaderField: "FID")
            } else {
                request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            }
            return request
        }, onSuccess: onSuccess)
    }
}
