//
//  NotificationAlertController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 08/06/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NotificationAlertController : UIAlertController, UIGestureRecognizerDelegate {
    var delegate: NotificationAlertControllerDelegate?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        
        let view = self.view!
        view.frame = CGRect(origin: CGPoint(x: (screenBounds.size.width - view.frame.size.width) * 0.5, y: 18), size: view.frame.size)
        
        setTapable(view: view)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { data in
            if self.isTapped == false {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setTapable(view: UIView) {
        if let label = view as? UILabel {
            label.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(gotoNotifications))
            gesture.delegate = self
            label.addGestureRecognizer(gesture)
        }
        
        for item in view.subviews {
            setTapable(view: item)
        }
    }
    
    var isTapped: Bool = false
    func gotoNotifications() {
        self.isTapped = true
        
        self.dismiss(animated: true, completion: { data in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "notifications") as! UINavigationController
            if let viewController = self.delegate as? UIViewController {
                viewController.present(nav, animated: true, completion: nil)
                self.isTapped = false
            }
        })
    }
}

protocol NotificationAlertControllerDelegate {
    
}
