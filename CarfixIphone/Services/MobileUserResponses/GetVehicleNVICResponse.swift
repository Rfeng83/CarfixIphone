//
//  GetVehiclesResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 21/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GetVehicleNVICResponse: MobileUserAPIResponse {
    public var Result: [GetVehicleNVICResult]?
}

class GetVehicleNVICResult: BaseAPIItem {
    public var NVIC: String?
}
