//
//  GetLocationAreasResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 10/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetLocationAreasResponse: CarFixAPIResponse {
    var Result: [GetLocationAreasStateResult]?
}

class GetLocationAreasStateResult: BaseAPIItem {
    var Name: String?
    var Areas: [GetLocationAreasResult]?
}

class GetLocationAreasResult: BaseAPIItem {
    var ID: Int32 = 0
    var Name: String?
}
