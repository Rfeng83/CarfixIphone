//
//  GetClaimEPaymentResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GetClaimEPaymentResponse: CarFixAPIResponse {
    var Result: GetClaimEPaymentResult?
}

class GetClaimEPaymentResult: BaseAPIItem {
    var IsBusiness: NSNumber?
    var BankName: String?
    var AccountName: String?
    var AccountNumber: String?
    var BankAddress: String?
    var SignaturePath: String?
}
