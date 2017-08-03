//
//  GetClaimDocumentsInPdfResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetClaimDocumentsInPdfResponse: CarFixAPIResponse {
    var Result: [GetClaimDocumentsInPdfResult]?
}

class GetClaimDocumentsInPdfResult: BaseAPIItem {
    var url: String?
    var title: String?
    var actionType: NSNumber?
}
