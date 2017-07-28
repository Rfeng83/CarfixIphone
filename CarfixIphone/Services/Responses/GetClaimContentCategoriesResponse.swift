//
//  GetClaimContentCategoriesResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetClaimContentCategoriesResponse: CarFixAPIResponse {
    var Result: GetClaimContentCategoriesResult?
}

class GetClaimContentCategoriesResult: BaseAPIItem {
    var DownloadClaimFormUrl: String?
    var Categories: [GetClaimContentCategoriesItem]?
}

class GetClaimContentCategoriesItem: BaseAPIItem {
    public var IsFulfilled: NSNumber?
    public var Title: String?
    public var Subtitle: String?
    public var ClaimContentCategoryId: Int = 0
}
