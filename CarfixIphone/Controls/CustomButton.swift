//
//  CustomButton.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    override func initView() -> CustomButton {
        _ = super.initView()
        
        self.backgroundColor = CarfixColor.primary.color
        self.tintColor = CarfixColor.white.color
        self.titleLabel?.font = self.titleLabel?.font.withSize(Config.buttonFontSize)
        
//        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: Config.buttonHeight)
    
        return self
    }
}
