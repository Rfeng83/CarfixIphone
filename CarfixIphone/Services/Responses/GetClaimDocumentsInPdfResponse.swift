//
//  GetClaimDocumentsInPdfResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetClaimDocumentsInPdfResponse: CarFixAPIResponse {
    var Result: GetClaimDocumentsInPdfResult?
}

class GetClaimDocumentsInPdfResult: BaseAPIItem {
    var claimAction: Int16 = -1
    var canUploadImage: NSNumber?
    var urls: [GetClaimDocumentsInPdfUrl]?
}

class GetClaimDocumentsInPdfUrl: BaseAPIItem {
    var url: String?
    var title: String?
    var windowTitle: String?
    var details: String?
    var actionType: NSNumber?
}

