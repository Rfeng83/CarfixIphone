//
//  SignaturePanel.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class SignaturePanel: DrawingPanel {
    override func initView() -> SignaturePanel {
        _ = super.initView()
        
        DispatchQueue.main.async {
            self.placeholder = "Press Here For a Second to Start Sign"
        }
        
        return self
    }
}
