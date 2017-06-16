//
//  CheckVersion.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 16/06/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class CheckVersionResponse: CarFixAPIResponse
{
    public var Result: CheckVersionResult?
}

class CheckVersionResult:BaseAPIItem
{
    public var needUpdate: Int16 = 0
    public var latestVersion: String?
}

