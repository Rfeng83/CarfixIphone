//
//  CheckUser.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/06/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class CheckUserResponse: CarFixAPIResponse
{
    public var Result: CheckUserResult?
}

class CheckUserResult:BaseAPIItem
{
    public var IsLoggedIn: Int16 = 0
}
