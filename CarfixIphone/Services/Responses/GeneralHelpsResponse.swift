//
//  GeneralHelpsResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GeneralHelpsResponse: CarFixAPIResponse {
    var Result: GeneralHelpsResult?
}

class GeneralHelpsResult: BaseAPIItem {
    var GeneralHelps: [LogCasePolicyItem]?
}
