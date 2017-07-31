//
//  PrimaryBackground.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class PrimaryBackground: UIView {
    override func initView() -> PrimaryBackground {
        _ = super.initView()
        self.backgroundColor = CarfixColor.primary.color
        let items: [CustomLabel] = self.getAllViews()
        for item in items {
            if item.textColor == UIColor.black {
                item.textColor = CarfixColor.white.color
            }
        }
        let images: [CustomImageView] = self.getAllViews()
        for image in images {
            if image.tintColor == UIImageView().tintColor {
                image.tintColor = CarfixColor.white.color
            }
        }
        
        return self
    }
}
