//
//  GetTruckAssignmentResponse.swift
//  Carfix
//
//  Created by Re Foong Lim on 23/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

public class GetTruckAssignmentResponse: MobileAPIResponse {
    public var Result: GetTruckAssignmentResult? = GetTruckAssignmentResult.init(obj: nil)
}

public class GetTruckAssignmentResult: BasicAPIItem
{
    public var Key: String?
    public var TruckNo: String?
    public var UserCode: String?
    public var CaseNo: String?
    public var VehRegNo: String?
    public var VehModel: String?
    public var PhoneNo: String?
    public var Service: NSNumber?
    public var BreakdownAddress: String?
    public var BreakdownLatitude: NSNumber?
    public var BreakdownLongitude: NSNumber?
    public var DestinationAddress: String?
    public var DestinationLatitude: NSNumber?
    public var DestinationLongitude: NSNumber?
}