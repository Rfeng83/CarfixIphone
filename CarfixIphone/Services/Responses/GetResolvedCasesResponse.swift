//
//  GetHistoryCasesResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 05/04/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetResolvedCasesResponse: CarFixAPIResponse {
    var Result: [GetResolvedCasesResult]?
}

class GetResolvedCasesResult: BaseAPIItem {
    var Key: String?
    var ReferenceNo: String?
    var IsClaim: NSNumber?
    var ClaimTypeID: NSNumber?
    var ServiceNeeded: String?
    var DriverURL: String?
    var Status: String?
    var CreatedDate: Date?
    var ModifiedDate: Date?
}
