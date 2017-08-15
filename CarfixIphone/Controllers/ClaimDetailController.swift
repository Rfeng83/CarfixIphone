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
        
        initButton(isCaseResolved: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = Config.lineHeight * 2
        
        if let item = getItems()?[indexPath.row] as? ClaimDetailItem {
            if let title = item.details {
                let width = ClaimDetailTableViewCell.titleWidth
                let label = CustomLabel(frame: CGRect(x: 0, y: 0, width: width, height: Config.lineHeight)).initView()
                label.text = title
                height = height + label.fitHeight()
            }
            
            if let content = item.content {
                if !content.isEmpty {
                    let width = UIScreen.main.bounds.width - Config.padding * 2 - Config.margin * 2
                    let label = CustomLabel(frame: CGRect(x: 0, y: 0, width: width, height: Config.lineHeight)).initView()
                    label.text = content
                    height = height + label.fitHeight() + Config.margin + Config.margin
                }
            }
        }
        return height
    }
    
    var mResult: GetClaimDetailResult?
    override func refresh(sender: AnyObject?) {
        if let key = key {
            CarFixAPIPost(self).getClaimDetail(key: key) { data in
                self.mResult = data?.Result
                if let result = self.mResult {
                    if let claimNo = result.ClaimFormNo {
                        self.txtCaseID.text = claimNo
                    } else {
                        self.txtCaseID.text = "\(result.ClaimID)"
                    }
                    self.txtClaimStatus.text = result.ClaimStatus
                    
                    if let logo = result.Logo {
                        ImageManager.downloadImage(mUrl: logo, imageView: self.imgInsurer)
                    }
                    
                    let isCaseResolved = Convert(result.IsCaseResolved).to() == true
                    self.initButton(isCaseResolved: isCaseResolved)
                    
                    if isCaseResolved {
                        self.performSegue(withIdentifier: Segue.segueCaseResolved.rawValue, sender: self)
                    }
                }
                
                super.refresh(sender: sender)
            }
        }
    }
    
    func initButton(isCaseResolved: Bool){
        btnUploadReply.isUserInteractionEnabled = !isCaseResolved
        btnDelete.isHidden = isCaseResolved
        
        if btnUploadReply.isUserInteractionEnabled {
            self.btnUploadReply.backgroundColor = CarfixColor.primary.color
        } else {
            self.btnUploadReply.backgroundColor = CarfixColor.gray500.color
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
        } else if let svc: UploadReplyController = segue.getMainController() {
            svc.key = self.key
            svc.delegate = self
        } else if let svc: NewClaimResultController = segue.getMainController() {
            svc.key = self.key
            svc.dontBacktoMainScreen = true
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
        var messageType: Int16!
        var content: String?
        required init(model: GetClaimDetailMessage) {
            super.init()
            
            self.title = model.CreatedDate?.forDisplay()
            self.messageType = model.MessageTypeID
            if let message = model.Message {
                self.details = "- \(message)"
            }
            self.content = model.Content
        }
    }
}

class ClaimDetailTableViewCell: CustomTableViewCell {
    var contentLabel: CustomLabel!
    var bottomBorder: CustomLine!
    static var titleWidth: CGFloat = 0
    override func initView() -> ClaimDetailTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        var x = margin + padding
        var y = Config.lineHeight
        let height: CGFloat = Config.lineHeight
        var width: CGFloat = Config.fieldExtraLongLabelWidth
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        x = x + width + Config.padding
        width = screenSize.width - x - Config.padding
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.lineBreakMode = .byWordWrapping
        self.detailsLabel.textColor = CarfixColor.gray800.color
        
        ClaimDetailTableViewCell.titleWidth = width
        
        x = Config.padding + Config.margin
        y = y + Config.lineHeight + Config.margin
        width = screenSize.width - Config.padding * 2 - Config.margin * 2
        self.contentLabel = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: Config.lineHeight)).initView()
        self.contentLabel.numberOfLines = 0
        self.contentLabel.lineBreakMode = .byWordWrapping
        self.contentLabel.textColor = CarfixColor.gray800.color
        self.addSubview(self.contentLabel)
        
        y = self.frame.height - Config.margin
        self.bottomBorder = CustomLine(frame: CGRect(x: 0, y: y, width: screenSize.width, height: Config.margin)).initView()
        self.bottomBorder.backgroundColor = CarfixColor.white.color
        self.addSubview(self.bottomBorder)
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        
        if let item = item as? ClaimDetailController.ClaimDetailItem {
            let oriHeight = self.detailsLabel.bounds.height
            let height = self.detailsLabel.fitHeight()
            self.detailsLabel.pushElementBelowIt(height: height - oriHeight)
            
            self.contentLabel.text = item.content
            _ = self.contentLabel.fitHeight()
            switch item.messageType {
            case 1:
                self.backgroundColor = CarfixColor.white.color
                let items: [CustomLabel] = self.getAllViews()
                for item in items {
                    item.textColor = CarfixColor.gray700.color
                }
            case 2:
                self.backgroundColor = CarfixColor.gray700.color
                let items: [CustomLabel] = self.getAllViews()
                for item in items {
                    item.textColor = CarfixColor.white.color
                }
            case 3:
                self.backgroundColor = CarfixColor.green.color
                let items: [CustomLabel] = self.getAllViews()
                for item in items {
                    item.textColor = CarfixColor.white.color
                }
            default:
                break
            }
            
            self.bottomBorder.frame.origin.y = self.frame.height - Config.margin
        }
    }
}

