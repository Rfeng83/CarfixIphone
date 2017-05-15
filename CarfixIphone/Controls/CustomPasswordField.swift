//
//  CustomPasswordField.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 25/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomPasswordField: CustomTextField {
    override func initView() -> CustomPasswordField {
        _ = super.initView()
        self.isSecureTextEntry = true
        return self
    }
}
