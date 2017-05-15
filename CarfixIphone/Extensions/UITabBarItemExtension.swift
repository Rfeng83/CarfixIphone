//
//  UITabItemExtension.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarItem {
    open override func awakeFromNib() {
        initControl()
    }
    
    func initControl() {
        // offset to center
        self.imageInsets = UIEdgeInsets(top:6,left:0,bottom:-6,right:0)
    }
}
