//
//  VehiclesController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class VehiclesController: BaseController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var notificationButton: NotificationBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = GradientView(frame: self.collectionView.bounds)
    }
    
    var oriTitle: String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        self.notificationButton.startGlowing()
    }
    
    var mItems: [GetVehiclesResult]?
    func refresh(){
        CarFixAPIPost(self, progressBar: false).getVehicles(key: nil, onSuccess: { data in
            self.mItems = data?.Result
            
            let count = self.mItems!.count
            self.mItems?.insert(GetVehiclesResult(obj: nil), at: count)
            
            let rows: CGFloat = ceil(CGFloat(self.mItems!.count) / 3)
            self.collectionViewHeight.constant = 108 * rows
            
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = self.view.bounds.width / 3.0
                let itemHeight = layout.itemSize.height
                layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
                layout.invalidateLayout()
                
                self.collectionViewHeight.constant = itemHeight * rows + Config.lineHeight
            }
            
            let pageHeight = UIScreen.main.bounds.height
            if self.collectionViewHeight.constant > pageHeight - 80 - 64 {
               self.collectionViewHeight.constant = pageHeight - 80 - 64
            }
            
            self.collectionView.reloadData()
            
            self.collectionView.backgroundView = GradientView(frame: self.collectionView.bounds)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let items = mItems {
            let item = items[indexPath.row]
            if item.Key.isEmpty {
                performSegue(withIdentifier: Segue.segueEditVehicle.rawValue, sender: item)
            } else {
                performSegue(withIdentifier: Segue.segueVehicle.rawValue, sender: item)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let item = sender as? GetVehiclesResult {
            if let nav = segue.destination as? UINavigationController {
                if let vc = nav.topViewController as? ViewVehicleController {
                    vc.key = item.Key
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
        
        var id: String!
        if item.Key == nil {
            id = "cell"
        } else if item.Image.isEmpty {
            id = "cellImage"
        } else {
            id = "cellImage"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        
        if let vehicleCell = cell as? VehicleViewCell {
            vehicleCell.setData(model: item)
        }
        
        return cell
    }
}

class VehicleViewCell: UICollectionViewCell {
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var label: CustomLabel!
    @IBOutlet weak var view: RoundedView!
    
    override func awakeFromNib() {
        self.label.textColor = CarfixColor.white.color
        self.image.tintColor = CarfixColor.white.color
    }
    
    func setData(model: GetVehiclesResult){
        if model.Image.hasValue {
            ImageManager.downloadImage(mUrl: model.Image!, imageView: self.image)
        } else {
            if model.Key == nil {
                self.view.backgroundColor = CarfixColor.primary.color
                self.image.image = #imageLiteral(resourceName: "ic_add_circle").withRenderingMode(.alwaysTemplate)
            } else {
                self.image.image = #imageLiteral(resourceName: "ic_vehicle_default")
            }
        }
        label.text = model.VehicleRegNo
    }
}
