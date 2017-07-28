//
//  SubmitSignedClaim.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class SubmitSignedClaimResponse: CarFixAPIResponse {
    var Result: SubmitSignedClaimResult?
}

class SubmitSignedClaimResult: BaseAPIItem {
    var key: String?
    var CaseID: String?
    var InsurerName: String?
    var InsurerEmail: String?
    var InsurerContact: String?
    var InsurerImage: String?
}
