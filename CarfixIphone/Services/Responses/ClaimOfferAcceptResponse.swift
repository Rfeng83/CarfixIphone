//
//  ClaimOfferAccept.swift
//  Carfix2
//
//  Created by Developer on 07/06/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
public class ClaimOfferAcceptResponse:MobileAPIResponse
{
    public var Result: ClaimOfferAcceptResult?
}

public class ClaimOfferAcceptResult:BasicAPIItem
{
    public var Key: String?
}

