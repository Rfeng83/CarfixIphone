//
//  ClaimApproveController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 01/08/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimApproveController: BaseFormController {
    var key: String?
    
    @IBOutlet weak var signatureInsured: SignaturePanel!
    @IBOutlet weak var signatureWitness: SignaturePanel!
    @IBOutlet weak var txtWitnessName: CustomTextField!
    @IBOutlet weak var txtICNumber: CustomTextField!
    @IBOutlet weak var viewIAgree: UIView!
    @IBOutlet weak var lblReadMore: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtWitnessName.isRequired = true
        txtICNumber.isRequired = true
        
        let gestureReadMore = UITapGestureRecognizer(target: self, action: #selector(readMore(_:)))
        lblReadMore.isUserInteractionEnabled = true
        lblReadMore.addGestureRecognizer(gestureReadMore)
        
        let gestureIAgree = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
        viewIAgree.isUserInteractionEnabled = true
        viewIAgree.addGestureRecognizer(gestureIAgree)
        checkIt(viewIAgree, agree: false)
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
    
    @IBAction func approveClaim(_ sender: Any) {
        if txtWitnessName.validateField() && txtICNumber.validateField() {
            if isAgreed {
                if let key = key {
                    if let insuredSignature = signatureInsured.getImage() {
                        var images = [String: UIImage]()
                        images.updateValue(insuredSignature, forKey: "InsuredSignature.png")
                        
                        if let witnessSignature = signatureWitness.getImage() {
                            images.updateValue(witnessSignature, forKey: "Witness.png")
                            
                            self.confirm(content: "Confirm to approve your claim?", handler: { data in
                                CarFixAPIPost(self).submitSignedDV(key: key, witnessName: self.txtWitnessName.text!, witnessIC: self.txtICNumber.text!, images: images) { data in
                                    self.dismissParentController(type: BaseTabBarController.self)
                                }
                            })
                        } else {
                            self.message(content: "Please sign before continue")
                        }
                    } else {
                        self.message(content: "Please sign before continue")
                    }
                }
            } else {
                self.message(content: "You must agree with the condition to continue")
            }
        } else {
            self.message(content: "Please fill in the required fields to continue")
        }
    }
}
