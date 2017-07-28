//
//  GetClaimWorkshopResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 26/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetClaimWorkshopResponse: CarFixAPIResponse {
    var Result: GetClaimWorkshopResult?
}

class GetClaimWorkshopResult: BaseAPIItem {
    var area: String?
    var workshop: String?
    var workshops: [ClaimWorkshops]?
}

class ClaimWorkshops: BaseAPIItem {
    var key: String?
    var CompanyName: String?
    var WorkshopAddress: String?
}
