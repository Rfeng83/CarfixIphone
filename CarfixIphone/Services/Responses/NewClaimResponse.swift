//
//  NewClaimResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 11/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class NewClaimResponse: CarFixAPIResponse {
    var Result: NewClaimResult?
}

class NewClaimResult: BaseAPIItem {
    var key: String?
    var CaseID: String?
    var InsurerName: String?
    var InsurerEmail: String?
    var InsurerContact: String?
    var InsurerImage: String?
}
