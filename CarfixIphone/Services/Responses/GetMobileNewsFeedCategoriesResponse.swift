//
//  GetMobileNewsFeedCategoryResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetMobileNewsFeedCategoriesResponse: CarFixAPIResponse {
    public var Result: [GetMobileNewsFeedCategoriesResult]?
}

class GetMobileNewsFeedCategoriesResult: BaseAPIItem {
    public var ID: Int = 0
    public var Name: String?
}
