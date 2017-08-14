//
//  SubmissionDocumentsController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 01/08/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class SubmissionDocumentsController: BaseTableViewController {
    var key: String?
    @IBOutlet weak var btnApprove: CustomButton!
    @IBOutlet weak var btnApproveHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .singleLine
        self.view.backgroundColor = CarfixColor.white.color
        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
        
        self.initApproveButton(claimAction: 0)
    }
    
    var mModel: GetClaimDetailResult?
    var mDocuments: [GetClaimDocumentsInPdfUrl]?
    override func refresh(sender: AnyObject?) {
        if let key = key {
            CarFixAPIPost(self).getClaimDocumentsInPdf(key: key) { data in
                //                self.mDownloadClaimFormUrl = data?.Result?.DownloadClaimFormUrl
                if let result = data?.Result {
                    self.mDocuments = result.urls
                    self.initApproveButton(claimAction: result.claimAction)
                    super.refresh(sender: sender)
                }
            }
        }
    }
    
    func initApproveButton(claimAction: Int16) {
        self.btnApprove.isHidden = claimAction == 0
        self.btnApprove.isEnabled = claimAction == 2
        if self.btnApprove.isEnabled {
            self.btnApprove.backgroundColor = CarfixColor.primary.color
        } else {
            self.btnApprove.backgroundColor = CarfixColor.gray500.color
        }
        
        if self.btnApprove.isHidden {
            self.btnApproveHeight.constant = 0
        } else {
            self.btnApproveHeight.constant = 49
        }
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let documents = mDocuments {
            for item in documents {
                items.append(SubmissionDocumentsItem(model: item))
            }
        }
        return items
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? SubmissionDocumentsItem {
            switch item.actionType! {
            case 0:
                performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: item)
            default:
                performSegue(withIdentifier: Segue.segueClaimDocument.rawValue, sender: self.key)
            }
        }
    }
    
    @IBAction func approveClaim(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueClaimApprove.rawValue, sender: key)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: ClaimRepairedPhotosController = segue.getMainController() {
            if let key = sender as? String {
                svc.key = key
            }
            svc.delegate = self
        } else if let svc: ClaimApproveController = segue.getMainController() {
            if let key = sender as? String {
                svc.key = key
            }
        } else if let svc: WebController = segue.getMainController() {
            if let model = sender as? SubmissionDocumentsItem {
                svc.title = model.windowTitle
                if let uri = URL(string: model.url!) {
                    let queryItems = [URLQueryItem(name: "embedded", value: "true"), URLQueryItem(name: "url", value: uri.absoluteString)]
                    var urlComps = URLComponents(string: "http://drive.google.com/viewerng/viewer")!
                    urlComps.queryItems = queryItems
                    svc.url = urlComps.url
                }
            }
        }
    }
    
    class SubmissionDocumentsItem: BaseTableItem {
        var actionType: Int16?
        var url: String?
        var windowTitle: String?
        required init(model: GetClaimDocumentsInPdfUrl) {
            super.init()
            self.title = model.title
            self.windowTitle = model.windowTitle ?? model.title
            self.details = model.details
            self.actionType = Convert(model.actionType).to()
            self.url = model.url
            self.leftImage = #imageLiteral(resourceName: "ic_chevron_right")
        }
    }
}

class SubmissionDocumentsTableViewCell: CustomTableViewCell {
    override func initView() -> CustomTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let iconSize: CGFloat = Config.lineHeight
        
        var x = margin + padding
        var y = Config.lineHeight + Config.lineHeight / 2
        let height: CGFloat = Config.lineHeight
        let width: CGFloat = screenSize.width - x - x - iconSize - Config.padding
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.lineBreakMode = .byWordWrapping
        
        x = x + width + Config.padding
        y = Config.lineHeight * 2 - iconSize / 2
        self.leftImage.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        self.leftImage.tintColor = CarfixColor.shadow.color
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        
        if let item = item as? SubmissionDocumentsController.SubmissionDocumentsItem {
            if item.details.hasValue {
                if let text = item.details {
                    let frame = self.titleLabel.frame
                    
                    self.detailsLabel.frame = frame
                    self.detailsLabel.text = text
                    
                    let height = self.detailsLabel.fitHeight()
                    let totalHeight = height + frame.height
                    let cellHeight = self.bounds.height
                    var y = (cellHeight - totalHeight) / 2
                    self.titleLabel.frame.origin.y = y
                    y = y + frame.height
                    self.detailsLabel.frame.origin.y = y
                }
            }
        }
    }
}
