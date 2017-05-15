//
//  KeyResponse.swift
//  Carfix2
//
//  Created by Developer on 02/09/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
class KeyResponse: CarFixAPIResponse
{
    public var Result: KeyResult?
}

class KeyResult: BaseAPIItem
{
    public var key: String?
}
