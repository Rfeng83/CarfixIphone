//
//  PanelWorkshopController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 10/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class PanelWorkshopController: BaseTableViewController, BaseTableReturnData {
    var delegate: BaseFormReturnData?
    var insurerName: String!
    
    @IBOutlet weak var pickerLocationArea: LocationAreaPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = CarfixColor.white.color
        self.tableView.estimatedRowHeight = Config.lineHeight * 4
        
        CarFixAPIPost(self).getLocationAreas() { data in
            var arr = [BaseTableGroup]()
            var startGroup: BaseTableGroup?
            if let result = data?.Result {
                for item in result {
                    if let areas = item.Areas {
                        if areas.count > 0 {
                            let group = BaseTableGroup()
                            group.title = item.Name
                            group.children = []
                            for child in areas {
                                let area = LocationAreaItem(model: child)
                                group.children?.append(area)
                            }
                            
                            if group.title == "Kuala Lumpur" {
                                startGroup = group
                            } else {
                                arr.append(group)
                            }
                        }
                    }
                }
            }
            
            arr.insert(startGroup!, at: 0)
            self.mLocationAreas = arr
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItems()?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? PanelWorkshopTableViewCell {
            if let item = getItems()?[indexPath.row] as? PanelWorkshopItem {
                if item == selectedRow {
                    initSelectedCell(indexPath: indexPath, cell: cell)
                }
            }
        }
        return cell
    }
    
    func initSelectedCell(indexPath: IndexPath, cell: PanelWorkshopTableViewCell) {
        cell.leftImage.isHidden = false
        cell.titleLabel.textColor = CarfixColor.primary.color
        cell.detailsLabel.textColor = CarfixColor.primary.color
        
        if let row = getItems()?[indexPath.row] as? PanelWorkshopItem {
            selectedRow = row
        }
    }
    
    var selectedRow: PanelWorkshopItem?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PanelWorkshopTableViewCell {
            initSelectedCell(indexPath: indexPath, cell: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PanelWorkshopTableViewCell {
            cell.leftImage.isHidden = true
            cell.titleLabel.textColor = CarfixColor.black.color
            cell.detailsLabel.textColor = CarfixColor.black.color
        }
    }
    
    var mAreaIDSelected: Int32?
    var mPanelWorkshops: [GetPanelWorkshopsResult]?
    func tableSelection(sender: BaseTableController, section: Int?, row: Int?) {
        if section.hasValue && row.hasValue {
            if let items = mLocationAreas[section!].children {
                let item = items[row!]
                if let item = item as? LocationAreaItem {
                    mAreaIDSelected = item.itemId
                    loadPanelWorkshops(title: item.title, workshop: nil)
                }
            }
        }
    }
    
    func loadPanelWorkshops(title: String?, workshop: String?) {
        if mLocationAreas.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { data in
                self.loadPanelWorkshops(title: title, workshop: workshop)
            }
        } else {
            selectedRow = nil
            pickerLocationArea.text = title
            
            var areaID: Int32?
            if mAreaIDSelected.hasValue {
                areaID = mAreaIDSelected!
            } else {
                for location in mLocationAreas {
                    if let items = location.children {
                        for area in items {
                            if let area = area as? LocationAreaItem {
                                if title == area.title {
                                    areaID = area.itemId
                                    break
                                }
                            }
                        }
                    }
                }
            }
            
            if let areaID = areaID {
                CarFixAPIPost(self).getPanelWorkshops(ins: insurerName, area: areaID) { data in
                    self.mPanelWorkshops = data?.Result
                    self.refresh(sender: nil)
                    
                    if let items = self.getItems() {
                        for i in 0...(items.count-1) {
                            if let item = items[i] as? PanelWorkshopItem {
                                if item.itemId == workshop {
                                    let indexPath = IndexPath(row: i, section: 0)
                                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                                    self.tableView(self.tableView, didSelectRowAt: indexPath)
                                    self.selectedRow = item
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        
        items.append(PanelWorkshopItem())
        if let result = mPanelWorkshops {
            for model in result {
                items.append(PanelWorkshopItem(model: model))
            }
        }
        
        return items
    }
    
    var mLocationAreas: [BaseTableGroup] = []
    func popupLocationArea() {
        performSegue(withIdentifier: Segue.segueFilter.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let svc = nav.topViewController as? FilterController {
                svc.delegate = self
                svc.title = "Pick Location Area"
                svc.tableView.tableHeaderView = nil
                
                var items: [FilterCategory] = []
                
                for group in mLocationAreas {
                    let item: FilterCategory = FilterCategory()
                    item.title = group.title
                    if let children = group.children {
                        for r in children {
                            item.children.append(r.title!)
                        }
                    }
                    items.append(item)
                }
                
                svc.filterCategories = items
                svc.refresh(sender: self.refreshControl)
            }
        }
        //        else if let svc = segue.destination as? NewClaimResultController {
        //            svc.companyName = offerService.Title
        //            svc.result = mResult ?? NewClaimResult(obj: nil)
        //        }
    }
    
    //    var mResult: NewClaimResult?
    @IBAction func submit(_ sender: Any) {
        if let selectedRow = self.selectedRow {
            self.delegate?.returnData(sender: self, item: selectedRow)
        } else {
            self.message(content: "Please select a Panel Workshop to continue...")
        }
    }
    
    class PanelWorkshopItem: BaseTableItem {
        var mModel: GetPanelWorkshopsResult?
        var itemId: String!
        
        override init() {
            super.init()
            
            self.itemId = ""
            self.title = "Skip"
            self.leftImage = #imageLiteral(resourceName: "ic_check_circle")
        }
        
        required convenience init(model: GetPanelWorkshopsResult) {
            self.init()
            
            if let key = model.key {
                itemId = key
            }
            self.title = model.CompanyName
            self.details = model.WorkshopAddress
            self.mModel = model
        }
    }
    
    class LocationAreaItem: BaseTableItem {
        var itemId: Int32!
        
        required init(model: GetLocationAreasResult) {
            super.init()
            
            itemId = model.ID
            title = model.Name
        }
    }
}

class PanelWorkshopTableViewCell: CustomTableViewCell {
    override func initView() -> PanelWorkshopTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let iconSize: CGFloat = Config.lineHeight
        
        var x = margin + padding
        var y = Config.lineHeight
        let width = screenSize.width - x * 2 - iconSize - margin
        let height: CGFloat = Config.lineHeight
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.lineBreakMode = .byWordWrapping
        
        x = x + width + margin
        y = Config.lineHeight * 2 - iconSize / 2
        self.leftImage.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        self.leftImage.tintColor = CarfixColor.green.color
        
        self.selectionStyle = .none
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        
        self.titleLabel.textColor = CarfixColor.black.color
        self.detailsLabel.textColor = CarfixColor.black.color
        self.leftImage.isHidden = true
        
        let detailsHeight = self.detailsLabel.fitHeight()
        if detailsHeight > Config.lineHeight {
            let margin = Config.margin
            let padding = Config.padding
            let height = self.titleLabel.frame.height
            let x = margin + padding
            var y = (Config.lineHeight * 4 - detailsHeight - height) / 2
            let width = UIScreen.main.bounds.width - x * 2 - Config.iconSize - margin
            
            self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
            y = y + height
            self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: detailsHeight)
        }
    }
}

class LocationAreaPicker: CustomTextField {
    override func initView() -> LocationAreaPicker {
        _ = super.initView()
        self.underlineOnly = false
        
        return self
    }
    
    override func drawRightView() {
        let rightView = UIImageView(image: #imageLiteral(resourceName: "ic_play_arrow"))
        let degrees: Double = 90
        let radians: Double = degrees * .pi / 180
        rightView.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
        rightView.tintColor = CarfixColor.gray800.color
        rightView.frame = CGRect(origin: rightView.frame.origin, size: CGSize(width: Config.iconSize, height: Config.iconSize))
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    override func becomeFirstResponder() -> Bool {
        self.parentViewController?.performSegue(withIdentifier: Segue.segueFilter.rawValue, sender: self)
        return true
    }
}
