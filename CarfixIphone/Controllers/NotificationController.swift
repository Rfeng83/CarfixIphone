//
//  NotificationController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NotificationController: BaseTableController {
    override func getBackgroundImage() -> UIImage? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .singleLine
        self.view.backgroundColor = CarfixColor.white.color
        
        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    var mResult: [GetNotificationResult]?
    override func refresh(sender: AnyObject?) {
        CarFixAPIPost(self).getNotification(onSuccess: { data in
            self.mResult = data?.Result
            super.refresh(sender: sender)
        })
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let result = mResult {
            for item in result {
                items.append(NotificationItem(model: item))
            }
        }
        return items
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? NotificationItem {
            if item.details?.contains("Policy not found") == true {
                CarFixAPIPost(self).generalHelps() { data in
                    let logData = LogCaseResult(obj: nil)
                    logData.GeneralHelps = data?.Result?.GeneralHelps
                    logData.Passcode = item.passcode
                    self.performSegue(withIdentifier: Segue.segueNoPolicy.rawValue, sender: logData)
                }
            } else if item.notificationTypeID == 2 {
                performSegue(withIdentifier: Segue.segueViewClaim.rawValue, sender: item.itemId)
            } else {
                performSegue(withIdentifier: Segue.segueCase.rawValue, sender: item.itemId)
            }
        }
    }
    
    let cellWidth: CGFloat = UIScreen.main.bounds.width - (Config.margin + Config.padding) * 2 - Config.lineHeight - Config.margin
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = Config.lineHeight * 2 + Config.padding * 2
        if let item = getItems()?[indexPath.row] {
            if let details = item.details {
                if details.height(with: cellWidth, font: Config.font) / Config.lineHeight > CGFloat(1) {
                    height += Config.lineHeight
                }
            }
        }
        return height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? CaseHistoryDetailsController {
                if let key = sender as? String {
                    vc.key = key
                }
            } else if let vc = nav.topViewController as? ViewClaimController {
                if let key = sender as? String {
                    vc.key = key
                }
            }
        } else if let nav = segue.destination as? NewCaseResultController {
            if let logData = sender as? LogCaseResult {
                nav.logData = logData
            }
        }
    }
    
    class NotificationItem: BaseTableItem {
        var itemId: String!
        var passcode: String?
        var notificationTypeID: NSNumber?
        
        required init(model: GetNotificationResult) {
            super.init()
            
            if let uniKey = model.UniKey {
                itemId = uniKey
            }
            
            if let caseNo = Convert(model.CaseID).to(Int.self) as? Int {
                if let serviceNeeded = ServiceNeeded(rawValue: Convert(model.ServiceNeeded).to()!) {
                    self.title = serviceNeeded.title
                    if caseNo > 0 {
                        self.title = "\(self.title!) | #\(caseNo)"
                        self.passcode = "\(caseNo)"
                    }
                }
                else {
                    self.title = "Claim"
                    if caseNo > 0 {
                        self.title = "\(self.title!) | #\(caseNo)"
                        self.passcode = "\(caseNo)"
                    }
                }
            }
            self.notificationTypeID = model.NotificationTypeID
            self.details = "\(model.Message!) - \(Convert(model.CreatedDate).countDown())"
            self.leftImage = #imageLiteral(resourceName: "ic_chevron_right")
        }
    }
}

class NotificationTableViewCell: CustomTableViewCell {
    override func initView() -> NotificationTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let iconSize: CGFloat = Config.lineHeight
        
        var x = margin + padding
        var y = padding
        let width = screenSize.width - x * 2 - iconSize - margin
        let height: CGFloat = Config.lineHeight
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.numberOfLines = 0
        y = y + height
        
        x = x + width + margin
        self.leftImage.frame = CGRect(x: x, y: (y + padding) / 2 - iconSize / 2, width: iconSize, height: iconSize)
        self.leftImage.tintColor = CarfixColor.gray800.color
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        let oriHeight = self.detailsLabel.frame.size.height
        let pushHeight = self.detailsLabel.fitHeight() - oriHeight
        if pushHeight != 0 {
            self.leftImage.frame = CGRect(origin: CGPoint(x: self.leftImage.frame.origin.x, y: self.frame.height / 2 - Config.lineHeight / 2), size: self.leftImage.frame.size)
        }
    }
}
