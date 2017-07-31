//
//  ClaimDeclarationController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimDeclarationController: BaseFormController {
    var key: String?
    
    @IBOutlet weak var viewInsuredSignature: SignaturePanel!
    @IBOutlet weak var viewDriverSignature: SignaturePanel!
    @IBOutlet weak var viewIAgree: UIView!
    @IBOutlet weak var lblReadMore: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func submit(_ sender: Any) {
        if isAgreed {
            if let key = key {
                if let insuredSignature = viewInsuredSignature.getImage() {
                    var images = [String: UIImage]()
                    images.updateValue(insuredSignature, forKey: "InsuredSignature.png")
                    
                    if let driverSignature = viewDriverSignature.getImage() {
                        images.updateValue(driverSignature, forKey: "DriverSignature.png")
                        
                        CarFixAPIPost(self).submitSignedClaim(key: key, images: images) { data in
                            self.performSegue(withIdentifier: Segue.segueNewClaimResult.rawValue, sender: key)
                        }
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let key = sender as? String {
            if let svc: NewClaimResultController = segue.getMainController() {
                svc.key = key
            }
        }
    }
}
