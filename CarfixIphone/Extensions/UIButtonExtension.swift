//
//  UIButtonExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 26/05/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import UIKit

extension UIButton {
    func setImageWithPath(path: String?) {
        if let imagePath = ImageManager.fileInDocumentsDirectory(path)
        {
            if let loadedImage = ImageManager.loadImageFromPath(imagePath) {
                print(" Loaded Image: \(loadedImage)")
                let img = loadedImage
                self.setImage(img, forState: .Normal)
            } else { print("some error message 2") }
        }
    }
    
}
