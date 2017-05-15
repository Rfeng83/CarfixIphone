//
//  ClaimDetailsHelpResponse.swift
//  Carfix2
//
//  Created by Re Foong Lim on 27/07/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

class ClaimDetailsHelpResponse: MobileAPIResponse {
    var Result: [ClaimDetailsHelpItem]?
}

class ClaimDetailsHelpItem: BasicAPIItem {
    var Title: String?
    var Details: String?
}