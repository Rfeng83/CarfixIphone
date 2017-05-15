//
//  ClaimCreateResponse.swift
//  Carfix2
//
//  Created by Re Foong Lim on 03/06/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

public class ClaimCreateResponse:MobileAPIResponse
{
    public var Result: ClaimCreateResult?
}

public class ClaimCreateResult:BasicAPIItem
{
    public var Key: String?
}
