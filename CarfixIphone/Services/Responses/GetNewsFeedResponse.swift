//
//  GetNewsFeedResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 21/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetNewsFeedResponse: CarFixAPIResponse {
    public var Result: [GetNewsFeedResult]?
}

class GetNewsFeedResult: BaseAPIItem {
    public var CategoryId: Int32 = 0
    public var Title: String?
    public var Description: String?
    public var ImagePath: String?
    public var ReferenceUrl: String?
    public var PublishedDate: Date?
}
