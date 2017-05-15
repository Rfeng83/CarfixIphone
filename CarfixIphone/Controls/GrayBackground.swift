//
//  CustomLine.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GrayBackground: UIView {
    override func initView() -> GrayBackground {
        self.backgroundColor = CarfixColor.gray100.color
        return self
    }
}
