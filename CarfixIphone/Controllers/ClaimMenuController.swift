//
//  WindscreenClaimController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimMenuController: BaseTableViewController, BaseFormReturnData {
    var key: String?
    var offerService: GetOfferServicesResult?
    var vehicle: GetVehiclesResult?
    
    @IBOutlet weak var btnPreviewSubmit: CustomButton!
    @IBOutlet weak var btnDelete: CustomImageView!
    @IBOutlet weak var txtVehicleNo: ExtraBigLabel!
    @IBOutlet weak var imgInsurer: CustomImageView!
    @IBOutlet weak var btnHelp: DarkIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtVehicleNo.text = self.vehicle?.VehicleRegNo
        
        if let url = offerService?.ImageURL {
            ImageManager.downloadImage(mUrl: url, imageView: imgInsurer)
        }
        
        self.tableView.separatorStyle = .singleLine
        self.view.backgroundColor = CarfixColor.white.color
        
        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
        
        self.tableView.estimatedRowHeight = Config.lineHeight * 4
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(deleteClaim(_:)))
        btnDelete.isUserInteractionEnabled = true
        btnDelete.addGestureRecognizer(gesture)
        
        let gestureHelp = UITapGestureRecognizer(target: self, action: #selector(help(sender:)))
        btnHelp.isUserInteractionEnabled = true
        btnHelp.addGestureRecognizer(gestureHelp)
        
        btnPreviewSubmit.isEnabled = false
    }
    
    var mResult: GetClaimContentCategoriesResult?
    override func refresh(sender: AnyObject?) {
        if let key = self.key {
            CarFixAPIPost(self).getClaimContentCategories(key: key) { data in
                self.mResult = data?.Result
                
                self.btnPreviewSubmit.isEnabled = self.mResult?.DownloadClaimFormUrl.hasValue == true
                
                super.refresh(sender: sender)
            }
        }
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        if let result = mResult?.Categories {
            for item in result {
                items.append(WindscreenCategoryItem(model: item))
            }
        }
        
        return items
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? WindscreenCategoryItem {
            if let category = ClaimContentCategoryEnum(rawValue: item.itemId) {
                switch category {
                case .MyDetail:
                    performSegue(withIdentifier: Segue.segueClaimPersonal.rawValue, sender: key)
                case .VehicleAccidentDetail:
                    performSegue(withIdentifier: Segue.segueClaimVehicle.rawValue, sender: key)
                case .BankDetail:
                    performSegue(withIdentifier: Segue.segueClaimBankDetails.rawValue, sender: key)
                case .DocumentImage:
                    performSegue(withIdentifier: Segue.segueClaimDocument.rawValue, sender: key)
                case .AccidentImage:
                    performSegue(withIdentifier: Segue.segueClaimAccidentImages.rawValue, sender: key)
                case .PanelWorkshops:
                    performSegue(withIdentifier: Segue.seguePanelWorkshops.rawValue, sender: key)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let key = sender as? String {
            if let svc: ClaimPersonalController = segue.getMainController() {
                svc.key = key
            } else if let svc: ClaimVehicleController = segue.getMainController() {
                svc.key = key
            } else if let svc: ClaimBankDetailsController = segue.getMainController() {
                svc.key = key
            } else if let svc: ClaimDeclarationController = segue.getMainController() {
                svc.key = key
            } else if let svc: ClaimImagesController = segue.getMainController() {
                svc.key = key
            } else if let svc: PanelWorkshopController = segue.getMainController() {
                svc.insurerName = self.offerService?.InsurerName ?? self.offerService?.Title
                svc.delegate = self
                
                CarFixAPIPost(self).getClaimWorkshop(key: key) { data in
                    if let result = data?.Result {
                        svc.loadPanelWorkshops(title: result.area, workshop: result.workshop)
                    }
                }
            } else if let svc: WebController = segue.getMainController() {
                if key.compare(titleWindscreen) == ComparisonResult.orderedSame {
                    let url = URL(string: "http://www.carfix.my/Blog/Pages/ViewPage/28")
                    svc.url = url
                    svc.title = key
                } else {
                    if let url = self.mResult?.DownloadClaimFormUrl {
                        svc.url = URL(string: url)
                        svc.delegate = self
                        svc.title = key
                    }
                }
            }
        }
    }
    
    func deleteClaim(_ sender: UIGestureRecognizer) {
        if let key = key {
            self.confirm(content: "Do you wish to delete this page and all its content?", handler: { data in
                CarFixAPIPost(self).deleteClaim(key: key) { data in
                    self.close(sender: self)
                }
            })
        }
    }
    
    var titleWindscreen: String = "Windscreen Claim"
    override func help(sender: AnyObject) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: titleWindscreen)
    }
    
    func returnData(sender: BaseController, item: Any) {
        if let item = item as? PanelWorkshopController.PanelWorkshopItem {
            if let key = key {
                CarFixAPIPost(self).updateClaimWorkshop(key: key, workshop: item.mModel?.key) { data in
                    sender.close(sender: sender)
                }
            }
        } else if let sender = sender as? WebController {
            sender.dismiss(animated: false) {
                self.performSegue(withIdentifier: Segue.segueClaimSubmit.rawValue, sender: self.key)
            }
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: "Preview & Submit")
    }
    
    class WindscreenCategoryItem: BaseTableItem {
        var itemId: Int!
        var isFullfilled: Bool!
        
        required public init(model: GetClaimContentCategoriesItem) {
            super.init()
            
            self.itemId = model.ClaimContentCategoryId
            self.isFullfilled = Convert(model.IsFulfilled).to() ?? false
            self.title = model.Title
            self.details = model.Subtitle
            self.leftImage = #imageLiteral(resourceName: "ic_check_circle")
        }
    }
}

class WindscreenCategoryTableViewCell: CustomTableViewCell {
    var rightImage: CustomImageView!
    //    var detailsX: CGFloat!
    //    var detailsWidth: CGFloat!
    
    override func initView() -> WindscreenCategoryTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        let iconSize: CGFloat = Config.lineHeight
        
        var x = margin + padding
        var y = Config.lineHeight
        let height: CGFloat = Config.lineHeight
        
        x = x + padding
        y = Config.lineHeight * 2 - iconSize / 2
        self.leftImage.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        self.leftImage.tintColor = CarfixColor.shadow.color
        
        x = x + iconSize + padding * 2
        let detailsX = x
        
        x = screenSize.width - (margin + padding) - iconSize
        y = Config.lineHeight * 2 - iconSize / 2
        self.rightImage = CustomImageView(frame: CGRect(x: x, y: y, width: iconSize, height: iconSize))
        self.rightImage.image = #imageLiteral(resourceName: "ic_chevron_right")
        self.rightImage.tintColor = CarfixColor.primary.color
        self.addSubview(self.rightImage)
        
        let width = x - padding - detailsX
        
        x = detailsX
        y = Config.lineHeight
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.lineBreakMode = .byWordWrapping
        self.detailsLabel.textColor = CarfixColor.gray800.color
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        
        if let item = item as? ClaimMenuController.WindscreenCategoryItem {
            if item.isFullfilled {
                self.leftImage.tintColor = CarfixColor.green.color
            }
        }
        
        let detailsHeight = self.detailsLabel.fitHeight()
        if detailsHeight > Config.lineHeight {
            let height = self.titleLabel.frame.height
            let x = self.detailsLabel.frame.origin.x
            var y = (Config.lineHeight * 4 - detailsHeight - height) / 2
            let width = self.detailsLabel.bounds.width
            
            self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
            y = y + height
            self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: detailsHeight)
        }
    }
}
