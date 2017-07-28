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
        if let imagePath = ImageManager.fileInDocumentsDirectory(filename: path)
        {
            if let loadedImage = ImageManager.loadImageFromPath(path: imagePath.absoluteString) {
                print(" Loaded Image: \(loadedImage)")
                let img = loadedImage
                self.setImage(img, for: .normal)
            } else { print("some error message 2") }
        }
    }
    
    var systemImage: UIBarButtonSystemItem? {
        get { return nil }
        set {
            if let value = newValue {
                let imageView = CustomImageView()
                imageView.systemImage = value
                if let image = imageView.image {
                    setImage(image, for: .normal)
                }
            }
        }
    }
}
