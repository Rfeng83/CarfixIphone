//
//  UIImageViewExtension.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    var systemImage: UIBarButtonSystemItem? {
        get { return nil }
        set {
            if let value = newValue {
                self.image = imageFromSystemBarButton(value)
            } else {
                self.image = nil
            }
        }
    }
    
    func imageFromSystemBarButton(_ systemItem: UIBarButtonSystemItem, renderingMode:UIImageRenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return UIImage()
    }
}
