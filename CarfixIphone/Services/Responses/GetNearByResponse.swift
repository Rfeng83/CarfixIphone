//
//  GetNearByResult.swift
//  Carfix
//
//  Created by Re Foong Lim on 22/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

public class GetNearByResponse:MobileAPIResponse
{
    public var Result: [GetNearByResult]?
}

public class GetNearByResult:BasicAPIItem
{
    public var Name: String?
    public var PhoneNo: String?
    public var Latitude: NSNumber?
    public var Longitude: NSNumber?
    public var Marker: String?
}