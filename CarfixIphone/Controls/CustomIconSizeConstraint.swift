//
//  CustomIconSizeConstraint.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomIconSizeConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        self.constant = Config.iconSize
    }
}
