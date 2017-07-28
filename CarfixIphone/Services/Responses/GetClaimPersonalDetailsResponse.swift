//
//  GetClaimPersonalDetailsResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GetClaimPersonalDetailsResponse: CarFixAPIResponse {
    var Result: GetClaimPersonalDetailsResult?
}

class GetClaimPersonalDetailsResult: BaseAPIItem {
    var key: String?
    var OwnerName: String?
    var OwnerIC: String?
    var OwnerTel: String?
    var OwnerMobile: String?
    var OwnerEmail: String?
    var OwnerGstNo: String?
    var isDriverTheOwner: NSNumber?
    var isBusiness: NSNumber?
    var DriverName: String?
    var DriverIC: String?
    var DriverTel: String?
    var DriverMobile: String?
    var LicenceType: String?
    var LicenceClass: String?
    var LicenceExpiredOn: Date?
    var LicenceIssuedOn: Date?
    var LicenceSuspended: NSNumber?
}
