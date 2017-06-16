//
//  BaseTabBarController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        let barItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ic_phone"), tag: 5)
        barItem.awakeFromNib()
        barItem.image = #imageLiteral(resourceName: "ic_phone")
        let contactUs = PhoneController()
        contactUs.tabBarItem = barItem
        self.viewControllers?.append(contactUs)
        
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CarfixInfo().profile.password.isEmpty && AccessToken.current.isEmpty {
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let selectedView = tabBarController.selectedViewController {
            if let nav = selectedView as? RedNavigationController {
                if let dest = nav.topViewController {
                    if dest is SeedController {
                        
                    } else if dest is NewsFeedController {
                        
                    } else if dest is VehiclesController {
                        
                    } else if dest is ServiceController {
                        
                    } else {
                        nav.popViewController(animated: false)
                    }
                }
            }
        }
        
        if type(of: viewController) == PhoneController.self {
            return false
        }
        
        //        let fromView: UIView = tabBarController.selectedViewController!.view
        //        let toView  : UIView = viewController.view
        //        if fromView == toView {
        //            return false
        //        }
        //
        //        UIView.transition(from: fromView, to: toView, duration: 0.3, options: .transitionCrossDissolve) { (finished:Bool) in
        //        }
        return true
    }
    
    var mPrevSelectedIndex: Int = 0
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 5:
            self.confirm(content: "Contact our call centre?", handler: {
                data in
                
                let phoneNo:String = "1300880133"
                //            if(CarFixInfo().setting.countryCode == Country.ph.rawValue){
                //                phoneNo = "+637981988"
                //            }
                
                if let url = URL(string: "tel://\(phoneNo)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            break
        default:
            mPrevSelectedIndex = self.selectedIndex
            break
        }
    }
}
