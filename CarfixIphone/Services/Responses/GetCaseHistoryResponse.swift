//
//  GetCaseHistoryResponse.swift
//  Carfix
//
//  Created by Re Foong Lim on 23/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

class GetSeedResponse: CarFixAPIResponse
{
    public var Result: [GetSeedResult]? = [GetSeedResult.init(obj: nil)]
}

class GetSeedResult: BaseAPIItem {
    public var key: String?
    public var IsClaim: NSNumber?
    public var ClaimTypeID: NSNumber?
    public var VehReg: String?
    public var Address: String?
    public var Passcode: String?
    public var ServiceNeeded: Int16 = 0
    public var CreatedDate: Date?
}
