//
//  GrayPanel.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class Gray700Background: PrimaryBackground {
    override func initView() -> Gray700Background {
        _ = super.initView()
        self.backgroundColor = CarfixColor.gray700.color
        return self
    }
}
