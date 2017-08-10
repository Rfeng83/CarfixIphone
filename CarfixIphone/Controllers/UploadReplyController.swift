//
//  UploadReplyController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 03/08/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class UploadReplyController: ClaimImagesController {
    @IBOutlet weak var viewUploadPhotos: UIView!
    @IBOutlet weak var viewUploadPhotosHeight: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: CustomTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMessage.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func loadExistingImages() -> Bool {
        return false
    }
    
    override func redrawImages() {
        self.drawImageUpload(category: .AddMorePhoto)
    }
    
    override func getImageContainer(category: PhotoCategory) -> UIView? {
        switch category {
        case .AddMorePhoto:
            return self.viewUploadPhotos
        default:
            return nil
        }
    }
    
    override func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        switch category {
        case .AddMorePhoto:
            return self.viewUploadPhotosHeight
        default:
            return nil
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if txtMessage.text.isEmpty {
            self.message(content: "Please write something to continue")
            return
        }
        
        let imageList = getNewImages()
        
        if let key = key {
            self.showProgressBar(msg: "The action might take few minutes to complete, please don’t close the apps until further instruction")
            
            CarFixAPIPost(self).uploadClaimPhotos(key: key, message: txtMessage.text, images: imageList) { data in
                self.mImages = [:]
                self.close(sender: self)
                self.delegate?.refresh(sender: self)
            }
        }
    }
    
}
