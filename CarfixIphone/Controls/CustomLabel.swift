//
//  CustomLabel.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    override func initView() -> CustomLabel {
        _ = super.initView()
        self.font = self.font.withSize(Config.fontSize)
        return self
    }
    
    func fitHeight() -> CGFloat {
        if let text = self.text {
            let height: CGFloat = text.height(with: self.frame.width, font: self.font)
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: height))
            return height
        }
        return 0
    }
    
    func fitWidth() -> CGFloat {
        if let text = self.text {
            let width: CGFloat = text.width(with: self.frame.height, font: self.font)
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: self.frame.height))
            return width
        }
        return 0
    }
    
    func pushElementBelowIt(height: CGFloat) {
        if let parent = self.superview {
            for element in parent.subviews {
                if element.frame.minY > self.frame.minY && (element.frame.minX < self.frame.maxX || element.frame.maxX < self.frame.minX) {
                    let newPoint = CGPoint(x: element.frame.origin.x, y: element.frame.origin.y + height)
                    element.frame = CGRect(origin: newPoint, size: element.frame.size)
                }
            }
        }
    }
}

class SmallLabel: CustomLabel {
    override func initView() -> SmallLabel {
        _ = super.initView()
        self.font = self.font.withSize(Config.fontSizeSmall)
        return self
    }
}

class BigLabel: CustomLabel {
    override func initView() -> BigLabel {
        _ = super.initView()
        self.font = self.font.withSize(Config.fontSizeBig)
        return self
    }
}

class ExtraBigLabel: CustomLabel {
    override func initView() -> ExtraBigLabel {
        _ = super.initView()
        self.font = self.font.withSize(Config.fontSizeExtraBig)
        return self
    }
}
