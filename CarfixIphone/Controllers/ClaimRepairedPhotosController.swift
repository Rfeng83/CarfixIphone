//
//  ClaimRepairedPhotosController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 03/08/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimRepairedPhotosController: ClaimImagesController {
    @IBOutlet weak var viewRepairedReceipt: UIView!
    @IBOutlet weak var viewRepairedReceiptHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRepairedPhotos: UIView!
    @IBOutlet weak var viewRepairedPhotosHeight: NSLayoutConstraint!
    var isApprovable: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initButton()
    }
    
    func initButton() {
        if isApprovable == true {
            btnUpload?.isEnabled = true
            btnUpload?.isHidden = false
            btnUploadHeight?.constant = 49
        } else {
            btnUpload?.isEnabled = false
            btnUpload?.isHidden = true
            btnUploadHeight?.constant = 0
        }
    }
    
    override func redrawImages() {
        self.drawImageUpload(category: .RepairedReceipt, canAdd: isApprovable == true)
        self.drawImageUpload(category: .AfterRepairedPhoto, canAdd: isApprovable == true)
    }
    
    override func getImageContainer(category: PhotoCategory) -> UIView? {
        switch category {
        case .RepairedReceipt:
            return self.viewRepairedReceipt
        case .AfterRepairedPhoto:
            return self.viewRepairedPhotos
        default:
            return nil
        }
    }
    
    override func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        switch category {
        case .RepairedReceipt:
            return self.viewRepairedReceiptHeight
        case .AfterRepairedPhoto:
            return self.viewRepairedPhotosHeight
        default:
            return nil
        }
    }
    
    override func existsImageRemovable() -> Bool {
        return isApprovable == true
    }
}
