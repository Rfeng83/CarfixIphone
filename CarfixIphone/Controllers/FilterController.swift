//
//  FilterController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class FilterController: NotificationController {    
    var delegate: BaseTableReturnData!
    @IBOutlet weak var viewAll: UIView!
    var filterCategories: [FilterCategory] = []
    var filterCategoryType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewAllTouched))
        viewAll.addGestureRecognizer(tapGesture)
    }
    
    override func buildItems() -> [BaseTableItem]? {
        return filterCategories
    }
    
    func viewAllTouched(sender: UITapGestureRecognizer) {
        self.delegate.tableSelection(sender: self, section: nil, row: nil)
        self.close(sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return getItems()?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == selectedCategory {
            if let items = getItems() {
                if let item = items[section] as? FilterCategory {
                    return item.children.count
                }
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let items = getItems() {
            if let item = items[section] as? FilterCategory {
                return item.title
            }
        }
        return ""
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category") as! FilterCategoryCell
        cell.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCategory))
        cell.contentView.addGestureRecognizer(tapGesture)
        cell.contentView.tag = section
        if section == selectedCategory {
            cell.rightImage.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
        } else {
            cell.rightImage.image = #imageLiteral(resourceName: "ic_chevron_right")
        }
        
        cell.bottomBorder.isHidden = section + 1 < getItems()!.count
        
        return cell
    }
    
    var selectedCategory: Int = 0
    func toggleCategory(sender: UITapGestureRecognizer) {
        if selectedCategory == sender.view!.tag {
            selectedCategory = -1
        } else {
            selectedCategory = sender.view!.tag
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterCell
        if let items = getItems() {
            if let item = items[indexPath.section] as? FilterCategory {
                cell.titleLabel.text = item.children[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.tableSelection(sender: self, section: indexPath.section, row: indexPath.row)
        self.close(sender: self)
    }
}

class FilterCategory: BaseTableItem {
    var children: [String]! = []
}
class FilterMonthYear: FilterCategory {
    var date: Date!
}

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = CarfixColor.gray100.color
    }
}

class FilterCategoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var bottomBorder: CustomLine!
}
