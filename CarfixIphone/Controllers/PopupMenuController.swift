//
//  PopupMenuController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 22/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class PopupMenuController: BaseController, UITableViewDelegate, UITableViewDataSource {
    var key: String?
    var items: [VehicleMenu] = [.DeletePage, .SetDefault, .EditDetails, .UpdateList]
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .popover
        self.view.backgroundColor = CarfixColor.gray800.color
    }
    
    override func getBackgroundImage() -> UIImage? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.popoverPresentationController?.delegate as? ViewVehicleController {
            self.dismiss(animated: true, completion: { data in
                vc.vehicleMenuTouched(menu: self.items[indexPath.row])
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.rawValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(Config.fontSize)
        cell.imageView?.image = item.image
        
        return cell
    }
}
