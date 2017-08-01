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
    
    var mDownloadClaimFormUrl: String?
    var mModel: GetClaimResult?
    override func refresh(sender: AnyObject?) {
        if let key = key {
            CarFixAPIPost(self).getClaimContentCategories(key: key) { data in
                self.mDownloadClaimFormUrl = data?.Result?.DownloadClaimFormUrl
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
        if let items = self.getItems() {
            self.btnApprove.isEnabled = true
            for item in items {
                if let item = item as? SubmissionDocumentsItem {
                    if !item.isEnabled {
                        self.btnApprove.isEnabled = false
                        break
                    }
                }
            }
        } else {
            self.btnApprove.isEnabled = false
        }
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        items.append(SubmissionDocumentsItem(title: titleClaimForm, enable: mDownloadClaimFormUrl.hasValue == true))
        items.append(SubmissionDocumentsItem(title: titleApprovalLetter, enable: mModel?.ApprovalLetterUrl.hasValue == true))
        items.append(SubmissionDocumentsItem(title: titleDischargeVoucher, enable: mModel?.DischargeVoucherUrl.hasValue == true))
        return items
    }
    
    var titleClaimForm = "My Claims Submission"
    var titleApprovalLetter = "Offer Letter"
    var titleDischargeVoucher = "Discharge Voucher"
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? SubmissionDocumentsItem {
            if item.isEnabled {
                switch item.title! {
                case titleClaimForm, titleApprovalLetter, titleDischargeVoucher:
                    performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: item.title)
                default:
                    performSegue(withIdentifier: Segue.segueViewSubmission.rawValue, sender: self.key)
                }
            }
        }
    }
    
    @IBAction func approveClaim(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueClaimApprove.rawValue, sender: key)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: ViewSubmissionController = segue.getMainController() {
            if let key = sender as? String {
                svc.key = key
            }
        } else if let svc: ClaimApproveController = segue.getMainController() {
            if let key = sender as? String {
                svc.key = key
            }
        } else if let svc: WebController = segue.getMainController() {
            if let title = sender as? String {
                svc.title = title
                var uri: URL?
                
                if title.compare(titleClaimForm) == .orderedSame {
                    if let url = mDownloadClaimFormUrl {
                        uri = URL(string: url)
                    }
                } else if title.compare(titleApprovalLetter) == .orderedSame {
                    if let url = self.mModel?.ApprovalLetterUrl {
                        uri = URL(string: url)
                    }
                } else if title.compare(titleDischargeVoucher) == .orderedSame {
                    if let url = self.mModel?.DischargeVoucherUrl {
                        uri = URL(string: url)
                    }
                }
                
                if let uri = uri {
                    let queryItems = [URLQueryItem(name: "embedded", value: "true"), URLQueryItem(name: "url", value: uri.absoluteString)]
                    var urlComps = URLComponents(string: "http://drive.google.com/viewerng/viewer")!
                    urlComps.queryItems = queryItems
                    svc.url = urlComps.url
                }
            }
        }
    }
    
    class SubmissionDocumentsItem: BaseTableItem {
        var isEnabled: Bool!
        required init(title: String?, enable: Bool) {
            super.init()
            self.title = title
            isEnabled = enable
            if isEnabled {
                self.leftImage = #imageLiteral(resourceName: "ic_chevron_right")
            }
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
