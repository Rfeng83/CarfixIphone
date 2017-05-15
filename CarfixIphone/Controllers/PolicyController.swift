//
//  PolicyController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class PolicyController: BaseFormController {
    var key: String?
    var serviceID: Int?
    var mModel: GetOfferServicesResult?
    
    @IBOutlet weak var imgPolicy: CustomImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = mModel?.ImageURL {
            ImageManager.downloadImage(mUrl: url, imageView: imgPolicy)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let svc = nav.topViewController as? NewClaimController {
                svc.key = self.key
                svc.serviceID = self.serviceID
                svc.mModel = self.mModel
            }
        }
    }
}
