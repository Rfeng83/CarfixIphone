//
//  LogCaseResponse.swift
//  Carfix
//
//  Created by Re Foong Lim on 23/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

class LogCaseResponse: CarFixAPIResponse
{
    public var Result:LogCaseResult? = LogCaseResult.init(obj:nil)
}

class LogCaseResult: BaseAPIItem
{
    public var Key:String?
    public var CaseNo:String?
    public var VehReg:String?
    public var PhoneNo:String?
    public var Address:String?
    public var Latitude:NSNumber?
    public var Longitude:NSNumber?
    public var VehModel:String?
    public var PolicyID:NSNumber?
    public var Passcode:String?
    public var ServiceNeeded:NSNumber?
    public var MatchedPolicies:[LogCasePolicyItem]?
    public var GeneralHelps:[LogCasePolicyItem]?
}

class LogCasePolicyItem: BaseAPIItem
{
    public var PolicyID:NSNumber?
    public var SubscriberName:String?
    public var Hotline:String?
    public var Logo:String?
}
