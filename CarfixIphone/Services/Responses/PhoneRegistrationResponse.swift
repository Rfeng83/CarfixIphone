//
//  PhoneRegistrationResponse.swift
//  Carfix
//
//  Created by Developer on 3/11/16.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation


class PhoneRegistrationResponse: CarFixAPIResponse
{
    public var Result: PhoneRegistrationResult?
}

class PhoneRegistrationResult: BaseAPIItem
{
    public var Role: NSNumber?
}
