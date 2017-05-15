//
//  GetBrandsResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetBrandsResponse: CarFixAPIResponse {
    public var Result: [GetBrandsResult]?
}

class GetBrandsResult: BaseAPIItem {
    public var Name: String?
}
