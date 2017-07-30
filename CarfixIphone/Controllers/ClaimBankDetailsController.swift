//
//  ClaimBankDetailsController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 22/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimBankDetailsController: ClaimImagesController {
    
    @IBOutlet weak var txtBankName: CustomTextField!
    @IBOutlet weak var txtAccNumber: CustomTextField!
    @IBOutlet weak var txtAccName: CustomTextField!
    //    @IBOutlet weak var txtBankAdd: CustomTextField!
    
    @IBOutlet weak var viewSignature: SignaturePanel!
    @IBOutlet weak var viewIAgree: UIView!
    
    @IBOutlet weak var lblReadMore: CustomLabel!
    
    @IBOutlet weak var viewImages: UIView!
    @IBOutlet weak var viewImagesHeight: NSLayoutConstraint!
    
    override func redrawImages() {
        drawImageUpload(category: .LatestBankStatement)
    }
    
    override func getImageContainer(category: PhotoCategory) -> UIView? {
        return viewImages
    }
    
    override func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        return viewImagesHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureReadMore = UITapGestureRecognizer(target: self, action: #selector(readMore(_:)))
        lblReadMore.isUserInteractionEnabled = true
        lblReadMore.addGestureRecognizer(gestureReadMore)
        
        let gestureIAgree = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
        viewIAgree.isUserInteractionEnabled = true
        viewIAgree.addGestureRecognizer(gestureIAgree)
        checkIt(viewIAgree, agree: false)
        
        singleFile = true
        refresh()
    }
    
    override func refresh() {
        if let key = key {
            CarFixAPIPost(self).getClaimEPayment(key: key) { data in
                if let result = data?.Result {
                    self.txtBankName.text = result.BankName
                    self.txtAccName.text = result.AccountName
                    self.txtAccNumber.text = result.AccountNumber
                    //                    self.txtBankAdd.text = result.BankAddress
                    self.redrawImages()
                }
            }
        }
    }
    
    func readMore(_ sender: UIGestureRecognizer) {
        
    }
    
    func isChecked(_ sender: UIGestureRecognizer) {
        if let view = sender.view {
            checkIt(view, agree: !isAgreed)
        }
    }
    
    var isAgreed: Bool = false
    func checkIt(_ item: UIView, agree: Bool) {
        isAgreed = agree
        let imgs: [CustomImageView] = item.getAllViews()
        for img in imgs {
            img.image = isAgreed ? #imageLiteral(resourceName: "ic_check_box") : #imageLiteral(resourceName: "ic_check_box_outline_blank")
            img.tintColor = isAgreed ? CarfixColor.primary.color : CarfixColor.gray800.color
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if isAgreed {
            if let key = key {
                var images = [String: UIImage]()
                if let signature = viewSignature.getImage() {
                    images.updateValue(signature, forKey: "OwnerSignature.png")
                    if let stamp = mImages?.first?.value.first {
                        images.updateValue(stamp, forKey: "CompanyStamp.png")
                    }
                    CarFixAPIPost(self).updateClaimEPayment(key: key, bankName: txtBankName.text, accountName: txtAccName.text, accountNumber: txtAccNumber.text, bankAddress: nil, images: images) { data in
                        self.close(sender: self)
                    }
                } else {
                    self.message(content: "Please sign before continue")
                }
            }
        } else {
            self.message(content: "You must agree with the condition to continue")
        }
    }
    
}
