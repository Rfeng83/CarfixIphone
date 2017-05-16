//
//  GetOfferServices.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 22/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GetOfferServicesResponse: MobileUserAPIResponse {
    var Result: [GetOfferServicesResult]?
}

class GetOfferServicesResult: BaseAPIItem {
    var ServiceID: Int = 0
    var ServiceName: String?
    var InsurerName: String?
    var Title: String?
    var SubTitle: String?
    var Price: NSNumber?
    var PriceBeforeDiscount: NSNumber?
    var DiscountPercent: NSNumber?
    var LastUpdated: Date?
    var IsTappable: Bool = false
    var OpenURL: String?
    var ImageURL: String?
}
