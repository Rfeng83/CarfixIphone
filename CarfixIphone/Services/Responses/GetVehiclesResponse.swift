//
//  GetVehiclesResponse.swift
//  Carfix2
//
//  Created by Developer on 02/09/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
class GetVehiclesResponse: CarFixAPIResponse
{
    public var Result: [GetVehiclesResult]?
}

class GetVehiclesResult: BaseAPIItem
{
    //public var Country: NSNumber?
    public var Key: String?
    public var VehicleRegNo: String?
    public var Brand: String?
    public var Model: String?
    public var VehYear: NSNumber?
    public var EngineCC: String?
    public var Transmission: String?
    public var Variant: String?
    public var NVIC: String?
    public var Image: String?
    public var IsDefault: NSNumber?
    public var PolicyEffDate: Date?
    public var PolicyExpDate: Date?
}
