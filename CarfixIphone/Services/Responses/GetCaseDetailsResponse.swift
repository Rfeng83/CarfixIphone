//
//  GetCaseDetailsResponse.swift
//  Carfix
//
//  Created by Re Foong Lim on 23/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

class GetCaseDetailsResponse: CarFixAPIResponse
{
    public var Result: GetCaseDetailsResult? = GetCaseDetailsResult.init(obj: nil)
}

class GetCaseDetailsResult: BaseAPIItem {
    public var CaseID: Int32 = 0
    public var ServiceNeeded: Int16 = 0
    public var CaseStatus: Int16 = 0
    public var Passcode: String?
    public var TruckNo: String?
    public var TruckLatitude: NSNumber?
    public var TruckLongitude: NSNumber?
    public var ArrivedTime: Date?
    public var Location: String?
    public var DriverName: String?
    public var ImageUrl: String?
    public var Latitude: NSNumber?
    public var Longitude: NSNumber?
    public var CreatedDate: Date?
    public var InsuranceName: String?
    public var InsImageURL: String?
    public var PolicyDue: String?

    public var data: [GetCaseDetailsLogData]?
}

class GetCaseDetailsLogData: BaseAPIItem {
    public var LogDate: Date?
    public var Message: String?
}
