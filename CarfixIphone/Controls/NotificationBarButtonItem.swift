//
//  File.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NotificationBarButtonItem: UIBarButtonItem {
    override func awakeFromNib() {
        let image: UIImage = #imageLiteral(resourceName: "ic_notifications")
        let button = CustomButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)).initView()
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.addTarget(self, action: #selector(touching), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
        button.addTarget(self, action: #selector(touched), for: .touchUpInside)
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            button.tintColor = CarfixColor.yellow.color
        }
        else{
            button.tintColor = CarfixColor.white.color
        }
        self.customView = button
    }
    
    func touchUp() {
        if let button = self.customView as? CustomButton {
            button.tintColor = CarfixColor.yellow.color
        }
    }
    func touching() {
        if let button = self.customView as? CustomButton {
            button.tintColor = CarfixColor.yellow.color.withAlphaComponent(0.2)
        }
    }
    
    func touched() {
        if let button = self.customView as? CustomButton {
            if UIApplication.shared.applicationIconBadgeNumber > 0 {
                button.tintColor = CarfixColor.yellow.color
            }
            else{
                button.tintColor = CarfixColor.white.color
            }
            var parent = button.parentViewController
            if let nav = parent as? UINavigationController {
                parent = nav.topViewController
            }
            if let vc = parent {
                vc.performSegue(withIdentifier: Segue.segueNotification.rawValue, sender: self)
            }
        }
    }
    
    
    func startGlowing() {
        if let button = self.customView as? CustomButton {
            if UIApplication.shared.applicationIconBadgeNumber > 0 {
                button.tintColor = CarfixColor.yellow.color
                self.customView?.startPulsing()
            }
            else{
                button.tintColor = CarfixColor.white.color
            }

        }
        
    }
}
