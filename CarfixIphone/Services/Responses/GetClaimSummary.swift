//
//  GetClaimResponse.swift
//
//
//  Created by Re Foong Lim on 12/05/2017.
//
//

import Foundation

class GetClaimSummaryResponse: CarFixAPIResponse {
    var Result: GetClaimSummaryResult?
}

class GetClaimSummaryResult: BaseAPIItem {
    var key: String?
    var CaseID: Int32 = 0
    var ReferenceNo: String?
    var InsurerName: String?
    var InsurerEmail: String?
    var InsurerContact: String?
    var InsurerImage: String?
    var claimStatus: String?
}
