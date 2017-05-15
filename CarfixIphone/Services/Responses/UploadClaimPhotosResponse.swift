//
//  UploadClaimPhotosResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 12/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class UploadClaimPhotosResponse: CarFixAPIResponse {
    var Result: UploadClaimPhotosResult?
}

class UploadClaimPhotosResult: BaseAPIItem {
    var Uploaded: Int32 = 0
}
