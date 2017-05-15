//
//  GetMakeItemsResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetSelectListItemsResponse: MobileUserAPIResponse {
    public var Result: [GetSelectListItemsResult]?
}

class GetSelectListItemsResult: BaseAPIItem {
    public var Text: String?
    public var Value: String?
}
