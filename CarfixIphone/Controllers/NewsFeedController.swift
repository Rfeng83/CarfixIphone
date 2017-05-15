//
//  NewsFeedController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedController: BaseTableController, BaseTableReturnData {
    
    @IBOutlet weak var notificationButton: NotificationBarButtonItem!
        
    var filterCategory: Int32?
    var filterYear: Int32?
    var filterMonth: Int32?
    var newsFeedCategoriesCached: [GetMobileNewsFeedCategoriesResult]?
    
    func tableSelection(sender: BaseTableController, section: Int?, row: Int?) {
        if let view = sender as? FilterController {
            switch view.filterCategoryType {
            case 1:
                if row.isEmpty {
                    filterCategory = nil
                    btnCategoryList.setTitle("Category List", for: .normal)
                } else {
                    let item = view.filterCategories[section!].children[row!]
                    filterCategory = Convert(newsFeedCategoriesCached![row!].ID).to()
                    btnCategoryList.setTitle(item, for: .normal)
                }
                break
            default:
                if row.isEmpty {
                    filterYear = nil
                    filterMonth = nil
                    btnMonthYear.setTitle("Month & Year", for: .normal)
                } else {
                    if let item = view.filterCategories[section!] as? FilterMonthYear {
                        let year = Calendar.current.component(.year, from: item.date)
                        if year == Calendar.current.component(.year, from: Date()) {
                            filterMonth = Convert(item.children.count - row!).to()
                        } else {
                            filterMonth = Convert(12 - row!).to()
                        }
                        filterYear = Convert(year).to()
                        
                        let date = Date(year: year, month: Int(filterMonth!), day: 1)!
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM yyyy"
                        dateFormatter.locale = NSLocale.current
                        btnMonthYear.setTitle(dateFormatter.string(from: date), for: .normal)
                    }
                }
                break
            }
            
            self.refresh(sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCategoryList.titleLabel?.font = Config.font
        btnCategoryList.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 4)
        btnCategoryList.imageView?.contentMode = .scaleAspectFit
        btnCategoryList.backgroundColor = UIColor(white: 0, alpha: 0.25)
        
        btnMonthYear.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 4)
        btnMonthYear.titleLabel?.font = Config.font
        btnMonthYear.imageView?.contentMode = .scaleAspectFit
        btnMonthYear.backgroundColor = UIColor(white: 0, alpha: 0.25)
        
        CarFixAPIPost(self).getMobileNewsFeedCategory() { data in
            if let result = data?.Result {
                self.newsFeedCategoriesCached = result
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationButton.startGlowing()
    }
    
    @IBOutlet weak var btnCategoryList: CustomButton!
    @IBOutlet weak var btnMonthYear: CustomButton!
    
    @IBAction func filterCategory(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueFilter.rawValue, sender: 1)
    }
    
    @IBAction func filterMonthYear(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueFilter.rawValue, sender: 2)
    }
    
    var mResult: [GetNewsFeedResult]?
    override func refresh(sender: AnyObject?) {
        CarFixAPIPost(self).getNewsFeed(category: filterCategory, year: filterYear, month: filterMonth, onSuccess: { data in
            if let data = data {
                self.mResult = data.Result
            } else {
                self.mResult = []
            }
            super.refresh(sender: sender)
        })
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let result = mResult {
            for item in result {
                items.append(NewsFeedItem(model: item))
            }
        }
        
        return items
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width - 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()![indexPath.row] as? NewsFeedController.NewsFeedItem {
            if !self.newsFeedCategoriesCached.isEmpty {
                performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: item)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let newsFeed = sender as? NewsFeedItem {
                if let svc = nav.topViewController as? WebController {
                    for item in newsFeedCategoriesCached! {
                        if item.ID == Convert(newsFeed.category).to()! {
                            svc.title = item.Name
                            break
                        }
                    }
                    
                    svc.url = newsFeed.url
                }
            } else if let svc = nav.topViewController as? FilterController {
                svc.delegate = self
                if let type = sender as? Int {
                    svc.filterCategoryType = type
                    
                    switch type {
                    case 1:
                        svc.title = btnCategoryList.titleLabel?.text
                        self.initFilterController(svc: svc, result: self.newsFeedCategoriesCached!)
                        break
                    default:
                        svc.title = btnMonthYear.titleLabel?.text
                        let currentDate = Date()
                        let calendar = Calendar.current
                        
                        var items: [FilterMonthYear] = []
                        
                        let minDate: Date = Date.init(year: 2016, month: 11, day: 1)!
                        
                        var lastDate: Date = currentDate
                        while lastDate.compare(minDate) == .orderedDescending ||
                            lastDate.compare(minDate) == .orderedSame {
                                let item: FilterMonthYear = FilterMonthYear()
                                let theYear = calendar.component(.year, from: lastDate)
                                item.title = "Year \(theYear)"
                                
                                item.date = lastDate
                                let firstDate = Date(year: theYear, month: 1, day: 2)!
                                
                                while (lastDate.compare(minDate) == .orderedDescending ||
                                    lastDate.compare(minDate) == .orderedSame) && (lastDate.compare(firstDate) == .orderedDescending || lastDate.compare(firstDate) == .orderedSame) {
                                        
                                        item.children.append(lastDate.toString(format: "MMMM"))
                                        lastDate = calendar.date(byAdding: .month, value: -1, to: lastDate)!
                                }
                                
                                items.append(item)
                        }
                        
                        svc.filterCategories = items
                        break
                    }
                }
            }
        }
    }
    
    func initFilterController(svc: FilterController, result: [GetMobileNewsFeedCategoriesResult]) {
        var items: [FilterCategory] = []
        let item: FilterCategory = FilterCategory()
        item.title = "Category"
        for r in result {
            item.children.append(r.Name!)
        }
        items.append(item)
        
        svc.filterCategories = items
        svc.refresh(sender: self.refreshControl)
    }
    
    override func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "bigNewsFeedCell", for: indexPath)
        //        if indexPath.row == 0 {
        //            return tableView.dequeueReusableCell(withIdentifier: "bigNewsFeedCell", for: indexPath)
        //        } else {
        //            return super.dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        //        }
    }
    
    class BaseNewsFeedItem: BaseTableItem {
        var date: Date?
    }
    class NewsFeedItem: BaseNewsFeedItem {
        var url: URL!
        var category: Int32?
        
        required init(model: GetNewsFeedResult) {
            super.init()
            
            self.title = model.Title
            self.details = model.Description
            self.leftImagePath = model.ImagePath
            self.date = model.PublishedDate
            self.category = model.CategoryId
            
            self.url = URL(string: model.ReferenceUrl ?? model.ImagePath!)
        }
    }
}

class NewsFeedTableViewCell: GradientTableViewCell {
    override func initView() -> NewsFeedTableViewCell {
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
        
        let imageWidth: CGFloat = height * 3 - margin
        self.leftImage.frame = CGRect(x: x, y: y + margin, width: imageWidth, height: imageWidth)
        
        x = x + imageWidth + margin + padding
        width = width - x
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height * 3)
        self.detailsLabel.numberOfLines = 3
        
        return self
    }
}

class BigNewsFeedTableViewCell: NewsFeedTableViewCell {
    var dateLabel: CustomLabel!
    override func initView() -> BigNewsFeedTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let x = margin + padding
        var y = padding
        let width = screenSize.width - x * 2
        let height: CGFloat = Config.lineHeight
        
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.numberOfLines = 0
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        self.dateLabel = SmallLabel(frame: CGRect(x: x, y: y, width: width, height: height)).initView()
        self.dateLabel.textColor = .white
        self.addSubview(self.dateLabel)
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height * 2)
        self.detailsLabel.numberOfLines = 2
        
        y = y + height * 2
        self.leftImage.frame = CGRect(x: x, y: y + margin, width: width, height: width - y)
        self.leftImage.contentMode = .scaleAspectFill
        self.leftImage.clipsToBounds = true
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        if let item = item as? NewsFeedController.NewsFeedItem {
            self.dateLabel.text = Convert(item.date).countDown()
        }
        
        let oriHeight = self.titleLabel.frame.size.height
        let heightToPush = self.titleLabel.fitHeight() - oriHeight
        if heightToPush != 0 {
            self.titleLabel.pushElementBelowIt(height: heightToPush)
            
            let newSize: CGSize = CGSize(width: self.leftImage.frame.width, height: self.leftImage.frame.height - heightToPush)
            self.leftImage.frame = CGRect(origin: self.leftImage.frame.origin, size: newSize)
        }
    }
}



