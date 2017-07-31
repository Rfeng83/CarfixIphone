//
//  SeedController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class SeedController: BaseTableController {
    var mHasVehicle: Bool?
    var mResult: [GetCaseHistoryResult]?
    var mNewsFeed: [GetNewsFeedResult]?
    var newsFeedCategoriesCached: [GetMobileNewsFeedCategoriesResult]?
    
    @IBOutlet weak var notificationButton: NotificationBarButtonItem!
    
    override func viewDidLoad() {
        self.initLayout()
        
        CarFixAPIPost(self).getMobileNewsFeedCategory() { data in
            if let result = data?.Result {
                self.newsFeedCategoriesCached = result
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationButton.startGlowing()
        
        self.refresh(sender: self)
    }
    
    override func refresh(sender: AnyObject?) {
        CarFixAPIPost(self).getProfile() { data in
            self.mHasVehicle = data?.Result?.VehicleRegNo.isEmpty == false
        }
        CarFixAPIPost(self).getCaseHistory() { data in
            if let result = data?.Result {
                self.mResult = result.reversed()
                super.refresh(sender: sender)
            }
        }
        CarFixAPIPost(self).getNewsFeed(category: nil, year: nil, month: nil) { data in
            if let result = data?.Result {
                self.mNewsFeed = result.reversed()
                super.refresh(sender: sender)
            }
        }
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items: [NewsFeedController.BaseNewsFeedItem] = []
        
        if mHasVehicle == false {
            items.append(CreateVehicleItem())
        }
        
        if let result = mNewsFeed {
            for item in result {
                items.append(NewsFeedController.NewsFeedItem(model: item))
            }
        }
        
        if let result = mResult {
            for item in result {
                items.append(SeedItem(model: item))
            }
        }
        
        items.sort(by: { a, b in
            return !a.date.isEmpty && !b.date.isEmpty && a.date!.compare(b.date!) == .orderedDescending
        })
        
        return items
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if getItems()?[indexPath.row] is NewsFeedController.NewsFeedItem {
            return UIScreen.main.bounds.width - 12
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getItems()![indexPath.row]
        if let item = item as? NewsFeedController.NewsFeedItem {
            if !self.newsFeedCategoriesCached.isEmpty {
                performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: item)
            }
        } else if let item = item as? SeedItem {
            if item.isWindscreen {
                performSegue(withIdentifier: Segue.segueViewWindscreen.rawValue, sender: item)
            } else if item.isClaim {
                performSegue(withIdentifier: Segue.segueViewClaim.rawValue, sender: item)
            } else {
                performSegue(withIdentifier: Segue.segueCase.rawValue, sender: item)
            }
        } else if item is CreateVehicleItem {
            performSegue(withIdentifier: Segue.segueEditVehicle.rawValue, sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let newsFeed = sender as? NewsFeedController.NewsFeedItem {
                if let svc: WebController = segue.getMainController() {
                    for item in newsFeedCategoriesCached! {
                        if item.ID == Convert(newsFeed.category).to()! {
                            svc.title = item.Name
                            break
                        }
                    }
                    
                    svc.url = newsFeed.url
                }
            }
            else if let seed = sender as? SeedItem {
                if let svc: CaseHistoryDetailsController = segue.getMainController() {
                    svc.key = seed.itemId!
                } else if let svc: ViewClaimController = segue.getMainController() {
                    svc.key = seed.itemId!
                } else if let svc: ClaimDetailController = segue.getMainController() {
                    svc.key = seed.itemId!
                }
            }
    }
    
    override func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = getItems()?[indexPath.row]
        if item is NewsFeedController.NewsFeedItem {
            return tableView.dequeueReusableCell(withIdentifier: "bigNewsFeedCell", for: indexPath)
        } else {
            return super.dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    class SeedItem: NewsFeedController.BaseNewsFeedItem {
        var itemId: String?
        var isClaim: Bool!
        var isWindscreen: Bool!
        
        required init(model: GetCaseHistoryResult) {
            super.init()
            
            self.itemId = model.key
            self.date = model.CreatedDate
            self.isClaim = model.IsClaim == true
            self.isWindscreen = model.ClaimTypeID == 2
            
            if let serviceNeeded = ServiceNeeded(rawValue: model.ServiceNeeded) {
                self.title = serviceNeeded.title
                self.leftImage = serviceNeeded.icon
            } else {
                self.title = "Claim"
                self.leftImage = #imageLiteral(resourceName: "ic_towing_services")
            }
            
            self.details = "\(Convert(model.CreatedDate).countDown())\n\(model.VehReg!)"
            
            //            let myMutableString = NSMutableAttributedString(
            //                string: string)
            //            myMutableString.addAttribute(NSForegroundColorAttributeName,
            //                                         value: CarfixColor.primary.color,
            //                                         range: (string as NSString).range(of: model.VehReg!))
            //            self.details = myMutableString
        }
    }
    
    class CreateVehicleItem: NewsFeedController.BaseNewsFeedItem {
        override init() {
            super.init()
            
            self.date = Date()
            self.title = "Setup Your Vehicle"
            self.details = "Click here to set up your vehicle. You can have more than one vehicle in your list"
            self.leftImage = #imageLiteral(resourceName: "ic_directions_car")
        }
    }
}

class SeedTableViewCell: GradientTableViewCell {
    override func initView() -> SeedTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        var x = margin + padding
        var y = padding
        var width = screenSize.width - x * 2
        let height: CGFloat = Config.lineHeight
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        let imageWidth: CGFloat = height * 2 - margin
        self.leftImage.frame = CGRect(x: x + margin, y: y + margin, width: imageWidth, height: imageWidth)
        self.leftImage.tintColor = .white
        
        x = x + imageWidth + margin + padding
        width = width - x
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height * 2)
        self.detailsLabel.numberOfLines = 2
        
        return self
    }
}

