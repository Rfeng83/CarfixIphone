//
//  GetProfileResponse.swift
//  Carfix2
//
//  Created by Developer on 02/09/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

class GetProfileResponse: CarFixAPIResponse
{
    public var Result: GetProfileResult?
}

class GetProfileResult:BaseAPIItem
{
    public var Country: Int16 = 0
    public var UserName: String?
    public var PhoneNo: String?
    public var Email: String?
    public var ProfileImage: String?
    public var VehicleRegNo: String?
    public var VehicleImage: String?
}
