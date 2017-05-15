//
//  BaseTableController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BaseTableController: UITableViewController {
    
    var mItems: [BaseTableItem]?
    
    override func getBackgroundImage() -> UIImage? {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        //        showInstruction()
        self.tableView.separatorStyle = .none
        
        if self.refreshControl.isEmpty {
            self.refreshControl = UIRefreshControl()
        }
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refresh(sender: nil)
    }
    
    func refresh(sender: AnyObject?) {
        mItems = buildItems()
        if let control = sender as? UIRefreshControl {
            control.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func buildItems() -> [BaseTableItem]? {
        return [BaseTableItem]()
    }
    
    func getItems() -> [BaseTableItem]? {
        return mItems
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.lineHeight * 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = getItems() {
            return items.count
        }
        return 0
    }
    
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        
        if let customCell = cell as? CustomTableViewCell {
            customCell.initCell(item: getItems()![indexPath.row])
        }
        
        return cell
    }
}
