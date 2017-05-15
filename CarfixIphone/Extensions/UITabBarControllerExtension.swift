//
//  UITabBarControllerExtension.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    open override func awakeFromNib() {
        initControl()
    }
    
    func initControl(){
        UITabBar.appearance().tintColor = CarfixColor.white.color
//        UITabBar.appearance().unselectedItemTintColor = CarfixColor.gray200.color
        
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [CarfixColor.gray700.color.cgColor, CarfixColor.gray800.color.cgColor]
        layerGradient.startPoint = CGPoint(x: 0.5, y: 0)
        layerGradient.endPoint = CGPoint(x: 0.5, y: 1)
        layerGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tabBar.bounds.height)
        tabBar.layer.addSublayer(layerGradient)
    }
}
