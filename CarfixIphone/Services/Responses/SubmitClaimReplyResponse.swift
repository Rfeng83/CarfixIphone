//
//  SubmitClaimReplyResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 26/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class SubmitClaimReplyResponse: CarFixAPIResponse {
    var Result: SubmitClaimReplyResult?
}

class SubmitClaimReplyResult: BaseAPIItem {
    var id: Int32 = 0
}
