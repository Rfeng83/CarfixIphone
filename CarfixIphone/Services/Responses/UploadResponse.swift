//
//  UploadResponse.swift
//  Carfix2
//
//  Created by Developer on 02/09/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

class UploadResponse: CarFixAPIResponse
{
    public var Result: UploadResult?
}

class UploadResult: BaseAPIItem
{
    public var downloadPath: String?
}
