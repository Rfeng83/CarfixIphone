//
//  GetMakeItemsResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GenTokenResponse: MobileUserAPIResponse {
    public var Result: GenTokenResult?
}

class GenTokenResult: BaseAPIItem {
    public var token: String?
}
