//
//  UIStoryboardSegue.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboardSegue {
    func getMainController<T>() -> T? {
        if let svc = self.destination as? T {
            return svc
        } else if let nav: UINavigationController = self.getNavController() {
            if let svc = nav.topViewController as? T {
                return svc
            }
        }
        return nil
    }
    
    func getNavController<T>() -> T? {
        if let nav = self.destination as? T {
            return nav
        }
        return nil
    }
}
