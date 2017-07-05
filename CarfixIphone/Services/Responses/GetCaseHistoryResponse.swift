//
//  GetCaseHistoryResponse.swift
//  Carfix
//
//  Created by Re Foong Lim on 23/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

class GetCaseHistoryResponse: CarFixAPIResponse
{
    public var Result: [GetCaseHistoryResult]? = [GetCaseHistoryResult.init(obj: nil)]
}

class GetCaseHistoryResult: BaseAPIItem {
    public var key: String?
    public var IsClaim: NSNumber?
    public var VehReg: String?
    public var Address: String?
    public var Passcode: String?
    public var ServiceNeeded: Int16 = 0
    public var CreatedDate: Date?
}
