//
//  ViewVehicleController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ViewVehicleController: BaseTableViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var image: RoundedImageView!
    @IBOutlet weak var imgSetDefault: UIImageView!
    
    @IBOutlet weak var viewVehicleInfo: UIView!
    @IBOutlet weak var lblVehicleNo: ExtraBigLabel!
    @IBOutlet weak var lblBrandModel: ExtraBigLabel!
    @IBOutlet weak var lblVehicleInfo: CustomLabel!
    
    override func viewDidLoad() {
        self.replaceViewDidLoad()
        
        self.imgSetDefault.tintColor = CarfixColor.white.color
        self.lblVehicleNo.textColor = CarfixColor.white.color
        self.lblBrandModel.textColor = CarfixColor.white.color
        self.lblVehicleInfo.textColor = CarfixColor.white.color
        
        let bottomY = self.viewVehicleInfo.frame.origin.y + self.viewVehicleInfo.frame.size.height
        
        let bounds = self.tableView.tableHeaderView!.bounds
        self.tableView.tableHeaderView?.bounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bottomY + Config.padding))
    }
    
    func replaceViewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        
        //        showInstruction()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        
        if self.refreshControl.isEmpty {
            self.refreshControl = UIRefreshControl()
        }
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh(sender: nil)
    }
    
    var key: String?
    var mModel: GetVehiclesResult?
    var mOfferServices: [GetOfferServicesResult]?
    override func refresh(sender: AnyObject?) {
        CarFixAPIPost(self).getVehicles(key: key, onSuccess: { data in
            if let result = data?.Result {
                if let model = result.first {
                    if let imagePath = model.Image {
                        ImageManager.downloadImage(mUrl: imagePath, imageView: self.image)
                    } else {
                        self.image.image = #imageLiteral(resourceName: "ic_vehicle_default")
                    }
                    
                    let isDefault: Bool = Convert(model.IsDefault).to()!
                    if isDefault {
                        self.imgSetDefault.image = #imageLiteral(resourceName: "ic_bookmark")
                    } else {
                        self.imgSetDefault.image = #imageLiteral(resourceName: "ic_bookmark_border")
                    }
                    
                    self.mModel = model
                    
                    var year: String
                    if model.VehYear.hasValue {
                        year = Convert(model.VehYear).to()!
                    } else {
                        year = ""
                    }
                    
                    self.lblVehicleNo.text = model.VehicleRegNo
                    self.lblBrandModel.text = "\(year) \(model.Brand ?? "") | \(model.Model ?? "")"
                    
                    var vehicleInfo: String = ""
                    //                    if model.Variant.hasValue {
                    //                        vehicleInfo = model.Variant!
                    //                    }
                    if model.Transmission.hasValue {
                        vehicleInfo = model.Transmission!//"\(vehicleInfo) \(model.Transmission!)"
                    }
                    if model.EngineCC.hasValue {
                        vehicleInfo = "\(vehicleInfo), \(model.EngineCC!) cc"
                    }
                    
                    self.lblVehicleInfo.text = vehicleInfo
                }
            }
            
            self.mOfferServices = []
            MobileUserAPI(self).getOfferServices(vehicleID: self.key!) { data in
                if let result = data?.Result {
                    self.mOfferServices = result
                    
                    super.refresh(sender: self.refreshControl)
                }
            }
        })
        
        super.refresh(sender: nil)
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let services = self.mOfferServices {
            for item in services {
                items.append(OfferServiceTableItem(model: item))
            }
        }
        
        return items
    }
    
    func vehicleMenuTouched(menu: VehicleMenu) {
        switch menu {
        case .DeletePage:
            deleteVehicle(self)
        case .SetDefault:
            setAsDefault()
        case .EditDetails:
            self.editVehicle(self)
        case .UpdateList:
            MobileUserAPI(self).updateServiceOffers(vehicleID: key!) { data in
                if data?.Succeed == true {
                    self.refresh(sender: self.refreshControl)
                }
            }
        }
    }
    
    func setAsDefault() {
        CarFixAPIPost(self).setDefaultVehicle(key: key!, onSuccess: { data in
            self.refresh(sender: self)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? OfferServiceTableItem {
            if let url = item.openUrl {
                UIApplication.shared.openURL(URL(string: url)!)
            } else if item.offerService == .Windscreen {
                if item.mModel?.InsurerName.hasValue == true {
                    self.performSegue(withIdentifier: Segue.segueClaimPolicy.rawValue, sender: item)
                } else {
                    self.message(content: "No policy found yet")
                }
            } else if item.isTappable {
                if let offerService = item.offerService {
                    MobileUserAPI(self).getServiceOffer(serviceID: offerService.rawValue, vehicleID: key!) { data in
                        self.refresh(sender: self)
                    }
                }
            } else {
                if item.offerService == .ValidPolicy || item.offerService == .ISearch {
                    self.performSegue(withIdentifier: Segue.seguePolicy.rawValue, sender: item)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let key = key {
            if let nav = segue.destination as? UINavigationController {
                if let svc = nav.topViewController as? EditVehicleController {
                    svc.key = key
                } else if let svc = nav.topViewController as? PolicyController {
                    if let sender = sender as? OfferServiceTableItem {
                        svc.key = key
                        svc.serviceID = sender.offerService?.rawValue
                        svc.mModel = sender.mModel
                    }
                } else if let svc = nav.topViewController as? ClaimPolicyController {
                    if let sender = sender as? OfferServiceTableItem {
                        svc.key = key
                        svc.mModel = sender.mModel
                        svc.mVehicle = self.mModel
                    }
                }
            } else if let menu = segue.destination as? PopupMenuController {
                menu.popoverPresentationController!.delegate = self
                menu.key = key
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func editVehicle(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueEditVehicle.rawValue, sender: key)
    }
    
    @IBAction func deleteVehicle(_ sender: Any) {
        confirm(content: "Are you confirm to delete your data?", handler: { data in
            if let model = self.mModel {
                CarFixAPIPost(self).deleteVehicle(key: self.key!, onSuccess: { data in
                    self.message(content: "The vehicle (\(model.VehicleRegNo!)) was deleted successfully", handler: { data in
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            }
        })
    }
    
    class OfferServiceTableItem: BaseTableItem {
        var mModel: GetOfferServicesResult?
        
        var offerService: OfferService?
        var price: NSNumber?
        var priceBeforeDiscount: NSNumber?
        var discountPercent: NSNumber?
        var lastUpdated: Date?
        var openUrl: String?
        var isTappable: Bool = false
        
        required init(model: GetOfferServicesResult) {
            super.init()
            
            self.offerService = OfferService(rawValue: model.ServiceID)
            self.title = model.Title
            self.details = model.SubTitle
            self.leftImagePath = model.ImageURL
            
            if model.OpenURL.hasValue {
                self.openUrl = model.OpenURL
            }
            self.isTappable = model.IsTappable
            
            self.price = model.Price
            self.priceBeforeDiscount = model.PriceBeforeDiscount
            self.discountPercent = model.DiscountPercent
            self.lastUpdated = model.LastUpdated
            
            self.mModel = model
        }
    }
}

class OfferServiceTableViewCell: GradientTableViewCell {
    var priceLabel: CustomLabel!
    var strikeOutLabel: CustomLabel!
    var remarksLabel: CustomLabel!
    var rightImage: CustomImageView!
    
    override func initView() -> OfferServiceTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        var x = padding
        var y = margin + margin / 2
        var width = screenSize.width - x * 2
        
        let imageWidth: CGFloat = Config.lineHeight * 4 - margin * 3
        self.leftImage.frame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
        self.leftImage.image = #imageLiteral(resourceName: "ic_vehicle_default")
        
        x = x + imageWidth + padding
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: Config.lineHeight)
        //        self.titleLabel.font = self.titleLabel.font.withSize(Config.fontSizeBig)
        
        self.priceLabel = CustomLabel(frame: CGRect(x: 0, y: y, width: width, height: Config.lineHeight)).initView()
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: Config.fontSize)
        self.priceLabel.textColor = CarfixColor.white.color
        self.priceLabel.isHidden = true
        self.addSubview(self.priceLabel)
        
        y = y + self.titleLabel.font.lineHeight
        width = width - x
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: Config.lineHeight * 2)
        self.detailsLabel.numberOfLines = 0
        
        self.strikeOutLabel = CustomLabel(frame: CGRect(x: 0, y: y, width: width, height: Config.lineHeight)).initView()
        self.strikeOutLabel.textColor = CarfixColor.white.color
        self.strikeOutLabel.isHidden = true
        self.addSubview(self.strikeOutLabel)
        
        self.remarksLabel = CustomLabel(frame: CGRect(x: 0, y: y, width: width, height: Config.lineHeight)).initView()
        self.remarksLabel.textColor = CarfixColor.white.color
        self.remarksLabel.isHidden = true
        self.addSubview(self.remarksLabel)
        
        let rightImageSize = Config.iconSizeBig
        y = (padding * 2 + Config.lineHeight * 3) / 2 - (rightImageSize / 2)
        x = screenSize.width - padding - rightImageSize
        
        self.rightImage = CustomImageView(frame: CGRect(x: x, y: y, width: rightImageSize, height: rightImageSize)).initView()
        self.rightImage.image = #imageLiteral(resourceName: "ic_chevron_right")
        self.rightImage.tintColor = CarfixColor.white.color
        self.addSubview(self.rightImage)
        self.rightImage.isHidden = true
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        
        self.detailsLabel.sizeToFit()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let totalWidth = screenSize.width - Config.padding * 2
        
        if let item = item as? ViewVehicleController.OfferServiceTableItem {
            if item.leftImagePath.isEmpty {
                self.leftImage.image = #imageLiteral(resourceName: "ic_appicon")
            } else {
                ImageManager.downloadImage(mUrl: item.leftImagePath!, imageView: self.leftImage)
            }
            if let price = item.price {
                if price.compare(0) == .orderedDescending {
                    self.priceLabel.text = Convert(price).toCurrency(showDecimail: false)
                    self.priceLabel.isHidden = false
                    let labelWidth = self.priceLabel.fitWidth()
                    
                    self.priceLabel.frame = CGRect(origin: CGPoint(x: totalWidth - labelWidth + Config.padding, y: self.priceLabel.frame.origin.y), size: self.priceLabel.frame.size)
                }
            }
            if self.priceLabel.text.isEmpty {
                self.priceLabel.isHidden = true
            }
            
            var remarksX: CGFloat = 0
            var remarks: String?
            if let value = item.discountPercent {
                remarks = Convert(value).to()
                remarks = "-\(remarks!)%"
            } else if let value = item.lastUpdated {
                remarks = Convert(value).countDown()
            }
            
            if let value = remarks {
                self.remarksLabel.text = Convert(value).to()
                self.remarksLabel.isHidden = false
                let labelWidth = self.remarksLabel.fitWidth()
                remarksX = totalWidth - labelWidth + Config.margin
                self.remarksLabel.frame = CGRect(origin: CGPoint(x: remarksX, y: self.remarksLabel.frame.origin.y), size: self.remarksLabel.frame.size)
            } else {
                self.remarksLabel.isHidden = true
            }
            
            if let value = item.priceBeforeDiscount {
                let attrString = NSAttributedString(string: Convert(value).toCurrency(showDecimail: false), attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
                self.strikeOutLabel.attributedText = attrString
                self.strikeOutLabel.isHidden = false
                let labelWidth = self.strikeOutLabel.fitWidth()
                let strikeOutX = remarksX - labelWidth - Config.margin
                self.strikeOutLabel.frame = CGRect(origin: CGPoint(x: strikeOutX, y: self.strikeOutLabel.frame.origin.y), size: self.strikeOutLabel.frame.size)
            }
            
            self.rightImage.isHidden = item.openUrl.hasValue || item.isTappable
        }
    }
}
