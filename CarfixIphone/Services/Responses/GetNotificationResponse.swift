//
//  GetNotificationResponse.swift
//  Carfix2
//
//  Created by Re Foong Lim on 07/06/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

class GetNotificationResponse: CarFixAPIResponse {
    var Result: [GetNotificationResult]?
}

class GetNotificationResult: BaseAPIItem {
    var UniKey: String?
    var NotificationTypeID: NSNumber?
    var Message: String?
    var CreatedDate: Date?
    var CaseID: NSNumber?
    var ServiceNeeded: NSNumber?
    var ClaimTypeID: NSNumber?
}
