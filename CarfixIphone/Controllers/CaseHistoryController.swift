//
//  NotificationController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CaseHistoryController: BaseTableController {
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
    
    var mResult: [GetResolvedCasesResult]?
    override func refresh(sender: AnyObject?) {
        CarFixAPIPost(self).getResolvedCases(onSuccess: { data in
            self.mResult = data?.Result
            super.refresh(sender: sender)
        })
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let result = mResult {
            for item in result {
                items.append(CaseHistoryItem(model: item))
            }
        }
        return items
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? CaseHistoryItem {
            if item.details?.contains("Policy not found") == true {
                CarFixAPIPost(self).generalHelps() { data in
                    let logData = LogCaseResult(obj: nil)
                    logData.GeneralHelps = data?.Result?.GeneralHelps
                    logData.Passcode = item.passcode
                    self.performSegue(withIdentifier: Segue.segueNoPolicy.rawValue, sender: logData)
                }
            } else {
                if item.isClaim {
                    performSegue(withIdentifier: Segue.segueViewClaim.rawValue, sender: item.itemId)
                } else {
                    performSegue(withIdentifier: Segue.segueCase.rawValue, sender: item.itemId)
                }
            }
        }
    }
    
    let cellWidth: CGFloat = UIScreen.main.bounds.width - (Config.margin + Config.padding) * 2 - Config.lineHeight - Config.margin
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        var height: CGFloat = Config.lineHeight * 2 + Config.padding * 2
        //        if let item = getItems()?[indexPath.row] {
        //            if let details = item.details {
        //                if details.height(with: cellWidth, font: Config.font) / Config.lineHeight > CGFloat(1) {
        //                    height += Config.lineHeight
        //                }
        //            }
        //        }
        //        return height
        return Config.fieldLabelWidth + Config.margin * 2 + Config.padding * 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let key = sender as? String {
                if let vc = nav.topViewController as? CaseHistoryDetailsController {
                    vc.key = key
                } else if let vc = nav.topViewController as? ViewClaimController {
                    vc.key = key
                }
            }
        } else if let nav = segue.destination as? NewCaseResultController {
            if let logData = sender as? LogCaseResult {
                nav.logData = logData
            }
        }
    }
    
    class CaseHistoryItem: BaseTableItem {
        var itemId: String!
        var passcode: String?
        var statusDesc: String?
        var isClaim: Bool!
        
        required init(model: GetResolvedCasesResult) {
            super.init()
            
            if let uniKey = model.Key {
                itemId = uniKey
            }
            
            self.title = model.ServiceNeeded
            self.details = Convert(model.CreatedDate).countDown()
            self.statusDesc = model.Status
            self.isClaim = model.IsClaim == 1
            if let image = model.DriverURL {
                self.leftImagePath = image
            } else {
                self.leftImage = #imageLiteral(resourceName: "ic_profile_default")
            }
        }
    }
}

class CaseHistoryTableViewCell: CustomTableViewCell {
    var statusLabel: CustomLabel!
    override func initView() -> CaseHistoryTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let iconSize: CGFloat = Config.fieldLabelWidth
        
        var x = margin + padding
        var y = margin + padding
        
        self.leftImage.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        self.leftImage.roundIt()
        
        let width = screenSize.width - x * 2 - iconSize - margin
        let height: CGFloat = Config.lineHeight
        
        x = x + iconSize + margin + padding
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        y = y + height + margin
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.numberOfLines = 0
        
        y = y + height + margin
        
        statusLabel = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: height)).initView()
        statusLabel.textColor = CarfixColor.green.color
        self.addSubview(statusLabel)
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        
        if let item = item as? CaseHistoryController.CaseHistoryItem {
            self.statusLabel.text = item.statusDesc
        }
        
        var totalHeight: CGFloat = 0
        totalHeight = totalHeight + self.titleLabel.fitHeight() + Config.margin
        totalHeight = totalHeight + self.detailsLabel.fitHeight() + Config.margin
        totalHeight = totalHeight + self.statusLabel.fitHeight()
        
        let rowHeight = self.frame.height
        let estimateTopMargin = (rowHeight - totalHeight) / 2
        
        let pushHeight = estimateTopMargin - self.titleLabel.frame.minY
        
        self.titleLabel.pushHeight(height: pushHeight)
        self.detailsLabel.pushHeight(height: pushHeight)
        self.statusLabel.pushHeight(height: pushHeight)
        
        //        let oriHeight = self.detailsLabel.frame.size.height
        //        let pushHeight = self.detailsLabel.fitHeight() - oriHeight
        //        if pushHeight != 0 {
        //            self.leftImage.frame = CGRect(origin: CGPoint(x: self.leftImage.frame.origin.x, y: self.frame.height / 2 - Config.lineHeight / 2), size: self.leftImage.frame.size)
        //        }
    }
}
