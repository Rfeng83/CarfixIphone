//
//  CustomView.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomView: UIView, Required {
    override func initView() -> CustomView {
        return self
    }
    
    private var mIsRequired: Bool = false
    var isRequired: Bool {
        get {
            return mIsRequired
        }
        set {
            mIsRequired = newValue
        }
    }
}
