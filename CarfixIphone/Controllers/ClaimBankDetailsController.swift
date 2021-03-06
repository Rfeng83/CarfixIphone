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
    @IBOutlet weak var viewCompanyStamp: UIView!
    @IBOutlet weak var viewIAgreeToContentBottom: NSLayoutConstraint!
    @IBOutlet weak var viewIAgreeToSignatureBottom: NSLayoutConstraint!
    
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
    }
    
    var mResult: GetClaimEPaymentResult?
    override func refresh() {
        if let key = key {
            CarFixAPIPost(self).getClaimEPayment(key: key) { data in
                self.mResult = data?.Result
                if let result = self.mResult {
                    self.txtBankName.text = result.BankName
                    self.txtAccName.text = result.AccountName
                    self.txtAccNumber.text = result.AccountNumber
                    //                    self.txtBankAdd.text = result.BankAddress
                    self.viewCompanyStamp.isHidden = !Convert(result.IsBusiness).to()!
                    self.viewIAgreeToContentBottom.isActive = self.viewCompanyStamp.isHidden
                    self.viewIAgreeToSignatureBottom.isActive = !self.viewCompanyStamp.isHidden
                    
                    if let image = result.SignaturePath {
                        if image.contains(".png") {
                            self.viewSignature.startDrawing()
                            ImageManager.downloadImage(mUrl: image, imageView: self.viewSignature.mainImageView, cache: false)
                        }
                    }
                    if let image = result.StampPath {
                        if image.contains(".png") {
                            self.mImagesExists = [:]
                            self.mImagesExists?.updateValue([ViewImageController.ViewImageItem(key: nil, path: image, image: nil)], forKey: PhotoCategory.LatestBankStatement)
                        }
                    }
                    
                    self.redrawImages()
                }
            }
        }
    }
    
    func readMore(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: WebController = segue.getMainController() {
            svc.url = URL(string: "http://www.carfix.my/Blog/Pages/ViewPage/26")
            svc.title = "Windscreen Claim"
        }
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
                if let signature = viewSignature.getImage() {
                    var images = [String: UIImage]()
                    images.updateValue(signature, forKey: "1;OwnerSignature.png")
                    
                    if let stamp = mImages?.first?.value.first {
                        images.updateValue(stamp, forKey: "2;CompanyStamp.png")
                    } else if mResult?.IsBusiness == 1 && mImagesExists?[PhotoCategory.LatestBankStatement]?.first.hasValue != true {
                        self.message(content: "Please upload your Company Stamp for the Business Vehicle")
                        return
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
