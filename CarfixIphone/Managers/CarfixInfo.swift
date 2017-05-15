//
//  CarfixInfo.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import CoreData

class CarfixInfo: DBHelper {
    private var mProfile: T_Profile?
    var profile: T_Profile {
        get {
            if mProfile == nil {
                mProfile = self.selectOrCreate(whereClause: "", parameters: nil)
            }
            return mProfile!
        }
    }
    
    func getCarfixContact() -> String {
        return "1300 88 0133"
    }
}
