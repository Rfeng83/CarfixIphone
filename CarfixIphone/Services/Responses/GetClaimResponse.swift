//
//  GetClaimResponse.swift
//  
//
//  Created by Re Foong Lim on 12/05/2017.
//
//

import Foundation

class GetClaimResponse: CarFixAPIResponse {
    var Result: GetClaimResult?
}

class GetClaimResult: BaseAPIItem {
    var CaseID: Int32 = 0
    var ClaimStatus: String?
    var ApprovalAmount: NSNumber?
    var IsApproved: NSNumber?
    var Workshop: String?
    var VehicleNo: String?
    var AccidentDate: Date?
    var AccidentLocation: String?
    var AccidentLatitude: NSNumber?
    var AccidentLongitude: NSNumber?
    var MobileNo: String?
    var ICNo: String?
    var InsurerName: String?
    var InsurerEmail: String?
    var InsurerContact: String?
    var InsurerImage: String?
    var PhotoCategories: [GetClaimPhotoCategory]?
}

class GetClaimPhotoCategory: BaseAPIItem {
    var Category: Int16 = 0
    var Images: [GetClaimImage]?
}

class GetClaimImage: BaseAPIItem {
    var Path: String?
}
