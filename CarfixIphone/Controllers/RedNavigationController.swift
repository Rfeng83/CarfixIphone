//
//  RedNavigationController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class RedNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = .black
        self.navigationBar.setBackgroundImage(UIImage.init(color: CarfixColor.primaryDark.color, size: CGSize(width: UIScreen.main.bounds.width, height: 20)), for: .default)
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = CarfixColor.white.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
