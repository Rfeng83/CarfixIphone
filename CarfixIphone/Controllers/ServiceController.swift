//
//  ServiceController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ServiceController: BaseController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var notificationButton: NotificationBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clear
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.notificationButton.startGlowing()
    }
    
    var mItems: [ServiceNeeded]?
    func refresh(){
        self.mItems = []
        for item in ServiceNeeded.cases {
            self.mItems?.append(item)
        }
        
        let count = self.mItems!.count
        
        let rows: CGFloat = ceil(CGFloat(count) / 2)
        self.collectionView.backgroundView = GradientView(frame: self.collectionView.bounds)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 2.0
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
            self.collectionViewHeight.constant = itemHeight * rows + Config.margin
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let items = mItems {
            performSegue(withIdentifier: Segue.segueNewCase.rawValue, sender: items[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? NewCaseController {
                if let item = sender as? ServiceNeeded {
                    vc.serviceNeeded = item
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = mItems {
            return items.count
        }
        else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = mItems![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let serviceCell = cell as? ServiceViewCell {
            serviceCell.setData(model: item)
        }
        
        return cell
    }
}

class ServiceViewCell: UICollectionViewCell {
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        self.label.textColor = CarfixColor.white.color
        self.image.tintColor = CarfixColor.white.color
    }
    
    func setData(model: ServiceNeeded){
        self.image.image = model.icon.withRenderingMode(.alwaysTemplate)
        self.label.text = model.title
    }
}
