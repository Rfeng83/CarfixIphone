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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .singleLine
        self.view.backgroundColor = CarfixColor.white.color
        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
        
        self.enableApproveButton()
    }
    
    //    var mDownloadClaimFormUrl: String?
    var mModel: GetClaimResult?
    var mDocuments: [GetClaimDocumentsInPdfResult]?
    override func refresh(sender: AnyObject?) {
        if let key = key {
            CarFixAPIPost(self).getClaimDocumentsInPdf(key: key) { data in
                //                self.mDownloadClaimFormUrl = data?.Result?.DownloadClaimFormUrl
                self.mDocuments = data?.Result
                
                super.refresh(sender: sender)
                CarFixAPIPost(self).getClaim(key: key) { data in
                    self.mModel = data?.Result
                    super.refresh(sender: sender)
                    self.enableApproveButton()
                }
            }
        }
    }
    
    func enableApproveButton() {
        //        if let items = self.getItems() {
        //            self.btnApprove.isEnabled = true
        //            for item in items {
        //                if let item = item as? SubmissionDocumentsItem {
        //                    if !item.isEnabled {
        //                        self.btnApprove.isEnabled = false
        //                        break
        //                    }
        //                }
        //            }
        //        } else {
        //            self.btnApprove.isEnabled = false
        //        }
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
        } else if let svc: ClaimApproveController = segue.getMainController() {
            if let key = sender as? String {
                svc.key = key
            }
        } else if let svc: WebController = segue.getMainController() {
            if let model = sender as? SubmissionDocumentsItem {
                svc.title = model.title
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
        required init(model: GetClaimDocumentsInPdfResult) {
            super.init()
            self.title = model.title
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
        
        x = x + width + Config.padding
        y = Config.lineHeight * 2 - iconSize / 2
        self.leftImage.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        self.leftImage.tintColor = CarfixColor.shadow.color
        
        return self
    }
}
