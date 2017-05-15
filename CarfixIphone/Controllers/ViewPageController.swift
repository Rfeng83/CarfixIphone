//
//  ViewPageController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ViewPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var image: RoundedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.separatorStyle = .none
        self.listTableView.backgroundColor = .clear
    }
    
    var navigationTitle: String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    var mItems: [BaseTableItem]?
    func refresh() {
        mItems = buildItems()
        
        listTableView.reloadData()
    }
    
    func buildModel() -> Any? {
        return nil
    }
    
    func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let model = buildModel() {
            let mirror = Mirror(reflecting: model)
            let children = mirror.getAllChildren()
            
            for i in children {
                let child = children[i]
                let item = BaseTableItem()
                item.title = "\(child.0.beautify()) :"
                if let value: String = Convert(child.1).to() {
                    item.details = value
                }
                items.append(item)
            }
        }
        return items
    }
    
    func getItems() -> [BaseTableItem]? {
        return mItems
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = getItems() {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let item = getItems()![indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.font = Config.font
        cell.detailTextLabel?.text = item.details
        cell.detailTextLabel?.font = Config.font
        
        return cell
    }
}
