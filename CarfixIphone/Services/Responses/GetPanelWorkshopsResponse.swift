//
//  GetPanelWorkshopsResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 10/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class GetPanelWorkshopsResponse: CarFixAPIResponse {
    var Result: [GetPanelWorkshopsResult]?
}

class GetPanelWorkshopsResult: BaseAPIItem {
    var key: String?
    var CompanyName: String?
    var WorkshopAddress: String?
}
