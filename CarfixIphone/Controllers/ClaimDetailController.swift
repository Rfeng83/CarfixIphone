//
//  ClaimDetailController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 31/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimDetailController: BaseTableViewController {
    var key: String?
    
    @IBOutlet weak var btnSubmissionDocuments: PrimaryBackground!
    @IBOutlet weak var btnUploadReply: PrimaryBackground!
    @IBOutlet weak var btnDelete: DarkIcon!
    
    @IBOutlet weak var imgInsurer: UIImageView!
    @IBOutlet weak var txtCaseID: CustomLabel!
    @IBOutlet weak var txtClaimStatus: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CarfixColor.white.color
        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
        
        let gestureSubmissionDocuments = UITapGestureRecognizer(target: self, action: #selector(submissionDocuments))
        btnSubmissionDocuments.isUserInteractionEnabled = true
        btnSubmissionDocuments.addGestureRecognizer(gestureSubmissionDocuments)
        
        let gestureUploadReply = UITapGestureRecognizer(target: self, action: #selector(uploadReply))
        btnUploadReply.isUserInteractionEnabled = true
        btnUploadReply.addGestureRecognizer(gestureUploadReply)
        
        let gestureCancelClaim = UITapGestureRecognizer(target: self, action: #selector(cancelClaim))
        btnDelete.isUserInteractionEnabled = true
        btnDelete.addGestureRecognizer(gestureCancelClaim)
    }
    
    var mResult: GetClaimDetailResult?
    override func refresh(sender: AnyObject?) {
        if let key = key {
            CarFixAPIPost(self).getClaimDetail(key: key) { data in
                self.mResult = data?.Result
                if let result = self.mResult {
                    self.txtCaseID.text = "\(result.ClaimID)"
                    self.txtClaimStatus.text = result.ClaimStatus
                    
                    if let logo = result.Logo {
                        ImageManager.downloadImage(mUrl: logo, imageView: self.imgInsurer)
                    }
                }
                
                super.refresh(sender: sender)
            }
        }
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let result = self.mResult?.Messages {
            for item in result {
                items.append(ClaimDetailItem(model: item))
            }
        }
        
        return items
    }
    
    func submissionDocuments() {
        performSegue(withIdentifier: Segue.segueSubmissionDocuments.rawValue, sender: self)
    }
    
    func uploadReply() {
        performSegue(withIdentifier: Segue.segueUploadReply.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: SubmissionDocumentsController = segue.getMainController() {
            svc.key = self.key
        }
    }
    
    func cancelClaim() {
        if let key = key {
            self.confirm(content: "Your submitted claim request will be cancelled. Do you wish to continue?", handler: { data in
                CarFixAPIPost(self).cancelClaim(key: key) { data in
                    self.close(sender: self)
                }
            })
        }
    }
    
    class ClaimDetailItem: BaseTableItem {
        required init(model: GetClaimDetailMessage) {
            super.init()
            
            self.title = model.Message
            self.details = model.Content
        }
    }
}

class ClaimDetailTableViewCell: CustomTableViewCell {
    override func initView() -> ClaimDetailTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let iconSize: CGFloat = Config.lineHeight
        
        var x = margin + padding
        var y = Config.lineHeight
        let height: CGFloat = Config.lineHeight
        
        x = x + padding
        y = Config.lineHeight * 2 - iconSize / 2
        self.leftImage.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        self.leftImage.tintColor = CarfixColor.shadow.color
        
        x = x + iconSize + padding * 2
        let detailsX = x
        
        x = screenSize.width - (margin + padding) - iconSize
        y = Config.lineHeight * 2 - iconSize / 2
        
        let width = x - padding - detailsX
        
        x = detailsX
        y = Config.lineHeight
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.lineBreakMode = .byWordWrapping
        self.detailsLabel.textColor = CarfixColor.gray800.color
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
                
        let detailsHeight = self.detailsLabel.fitHeight()
        if detailsHeight > Config.lineHeight {
            let height = self.titleLabel.frame.height
            let x = self.detailsLabel.frame.origin.x
            var y = (Config.lineHeight * 4 - detailsHeight - height) / 2
            let width = self.detailsLabel.bounds.width
            
            self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
            y = y + height
            self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: detailsHeight)
        }
    }
}

