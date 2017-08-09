//
//  GetClaimResponse.swift
//
//
//  Created by Re Foong Lim on 12/05/2017.
//
//

import Foundation

class GetClaimPhotosResponse: CarFixAPIResponse {
    var Result: GetClaimPhotosResult?
}

class GetClaimPhotosResult: BaseAPIItem {
    var PhotoCategories: [GetClaimPhotoCategory]?
}
