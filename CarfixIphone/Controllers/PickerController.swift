//
//  FilterController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/01/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class PickerController: BaseTableController {
    var delegate: BaseTableReturnData!
    var options: [BaseTableItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CarfixColor.white.color
        self.tableView.separatorStyle = .singleLine
        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func buildItems() -> [BaseTableItem]? {
        return options
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0

        if let options = getItems() {
            for item in options {
                if type(of: item) == BaseTableGroup.self {
                    count = count + 1
                }
            }
            
            if count == 0 {
                return 1
            }
        }
        
        return count
    }
    
    func hasGroup() -> Bool {
        return numberOfSections(in: tableView) > 1
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var items = [String]()
        if let options = getItems() {
            for item in options {
                if type(of: item) == BaseTableGroup.self {
                    items.append(item.title!)
                }
            }
        }
        
        return items
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = getItems() {
            if hasGroup() {
                if let item = items[section] as? BaseTableGroup {
                    return item.children?.count ?? 0
                }
            }
        
            return items.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let items = getItems() {
            var item: BaseTableItem
            if hasGroup() {
                item = items[indexPath.section]
                if let group = item as? BaseTableGroup {
                    if let child = group.children?[indexPath.row] {
                        item = child
                    }
                }
            } else {
                item = items[indexPath.row]
            }
            cell.textLabel?.text = item.title
            cell.separatorInset = UIEdgeInsets.zero
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.tableSelection(sender: self, section: indexPath.section, row: indexPath.row)
        self.close(sender: self)
    }
    
    @IBAction func clearText(_ sender: Any) {
        self.delegate.tableSelection(sender: self, section: nil, row: nil)
        self.close(sender: self)
    }
}
