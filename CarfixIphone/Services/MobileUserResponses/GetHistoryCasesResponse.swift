//
//  GetHistoryCasesResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 05/04/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetHistoryCasesResponse: MobileUserAPIResponse {
    var Result: [GetHistoryCasesResult]?
}

class GetHistoryCasesResult: BaseAPIItem {
    var Key: String?
    var IsClaim: NSNumber?
    var ServiceNeeded: String?
    var DriverURL: String?
    var Status: String?
    var CreatedDate: Date?
}
