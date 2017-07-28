//
//  GrayPanel.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class Gray700Background: UIView {
    override func initView() -> Gray700Background {
        self.backgroundColor = CarfixColor.gray700.color
        let items: [CustomLabel] = self.getAllViews()
        for item in items {
            item.textColor = CarfixColor.white.color
        }
        
        return self
    }
}
