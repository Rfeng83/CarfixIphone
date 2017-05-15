//
//  GetClaimsResponse.swift
//  Carfix2
//
//  Created by Re Foong Lim on 06/06/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

class GetClaimsResponse: MobileAPIResponse {
    var Result: [GetClaimsResult]?
}

class GetClaimsResult: BasicAPIItem {
    var Key: String?
    var DefaultImage: String?
    var VehicleNo: String?
    var AccidentDate: NSDate?
    var ClaimStatus: String?
}