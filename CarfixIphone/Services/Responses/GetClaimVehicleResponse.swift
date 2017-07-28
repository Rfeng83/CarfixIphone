//
//  GetClaimVehicleResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 21/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetClaimVehicleResponse: CarFixAPIResponse {
    var Result: GetClaimVehicleResult?
}

class GetClaimVehicleResult: BaseAPIItem {
    var key: String?
    var EngineNo: String?
    var ChassisNo: String?
    var DateOfAcc: Date?
    var PlaceOfAcc: String?
    var PoliceReportNo: String?
    var IsInsuredConsent: NSNumber?
    var VehiclePurpose: String?
    var RoadSide: String?
    var AccLatitude: NSNumber?
    var AccLongitude: NSNumber?
}
