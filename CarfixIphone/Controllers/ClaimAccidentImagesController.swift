//
//  ClaimDocumentController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimAccidentImagesController: ClaimImagesController {
    @IBOutlet weak var viewImages: UIView!
    @IBOutlet weak var viewImagesHeight: NSLayoutConstraint!
    
    override func redrawImages() {
        self.drawImageUpload(category: .DamagedVehicle)
    }
    
    override func getImageContainer(category: PhotoCategory) -> UIView? {
        return viewImages
    }
    
    override func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        return viewImagesHeight
    }
}
