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
}
