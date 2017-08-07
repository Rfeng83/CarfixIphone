//
//  GetClaimDetailResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 31/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GetClaimDetailResponse: CarFixAPIResponse {
    var Result: GetClaimDetailResult?
}

class GetClaimDetailResult: BaseAPIItem {
    var ClaimID: Int32 = 0
    var ClaimNo: String?
    var ClaimStatusID: Int16 = 0
    var IsCaseResolved: NSNumber?
    var ClaimStatus: String?
    var Logo: String?
    var Messages: [GetClaimDetailMessage]?
}

class GetClaimDetailMessage: BaseAPIItem {
    var CreatedDate: Date?
    var Message: String?
    var Content: String?
    var MessageTypeID: Int16 = 0
}
