//
//  NewClaimController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class NewClaimController: BaseFormController, CustomEditPageDelegate, HasImagePicker, UIGestureRecognizerDelegate, ViewImageControllerDelegate, NewClaimMapControllerDelegate, BaseFormReturnData {
    var key: String?
    var serviceID: Int?
    var mModel: GetOfferServicesResult?
    
    @IBOutlet weak var editPage: CustomEditPage!
    
    var mVehicle: GetVehiclesResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let key = key {
            CarFixAPIPost(self).getVehicles(key: key) { data in
                self.mVehicle = data?.Result?.first
                
                self.editPage.refresh()
            }
        }
    }
    
    var mItem: NewClaimModel?
    func buildModel() -> NSObject {
        var item: NewClaimModel
        
        if let mItem = mItem {
            item = mItem
        } else {
            item = NewClaimModel()
            
            if let model = self.mVehicle {
                item.vehicleNo = model.VehicleRegNo
            }
            item.accidentDate = Date.init()
            item.mobileNo = CarfixInfo().profile.loginID
        }
        
        return item
    }
    
    func buildItem(_ item: BaseTableItem) -> BaseTableItem {
        if item.name == "icNo" {
            item.title = "IC No."
        } else if item.name == "mobileNo" {
            item.title = "Mobile No."
        } else if item.name == "vehicleNo" {
            item.title = "Vehicle No."
        }
        return item
    }
    
    func buildField(name: String, item: BaseTableItem, field: UIView) -> UIView {
        var customField = field as! CustomTextField
        if name == "accidentDate" {
            customField = CustomDateTimePicker(frame: customField.frame).initView()
            customField.name = name
        } else if name == "mobileNo" {
            customField = CustomPhoneField(frame: customField.frame).initView()
            customField.name = name
            customField.isEnabled = false
        } else if name == "vehicleNo" {
            customField.isEnabled = false
        } else if name == "address" {
            let view = CustomView(frame: field.frame).initView()
            view.isRequired = true
            let padding: CGFloat = 2
            var x = padding
            var y: CGFloat = Config.padding
            var width = view.frame.size.width - padding
            var height = view.frame.size.height
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let text = CustomLabel(frame: frame).initView()
            text.font = text.font.withSize(Config.editFontSize)
            text.numberOfLines = 0
            
            if let model = mItem {
                text.text = model.address
            }
            
            if text.text.isEmpty {
                text.text = "Tap to add accident address..."
            }
            
            view.addSubview(text)
            
            x = 0
            y = Config.padding + text.fitHeight() + Config.padding
            width = view.frame.width
            height = 1
            let border = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
            border.backgroundColor = CarfixColor.gray800.color
            view.addSubview(border)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addAddress(_:)))
            tapGesture.delegate = self
            text.isUserInteractionEnabled = true
            text.addGestureRecognizer(tapGesture)
            
            view.adjustSize()
            
            return view
        }
        
        if name == "accidentDate" || name == "icNo" {
            customField.isRequired = true
        }
        
        return customField
    }
    
    func addAddress(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueNewClaimMap.rawValue, sender: self)
    }
    
    var mLocation: CLLocation?
    func updateAddress(address: String?, location: CLLocation?) {
        mItem = self.editPage.getResult() as? NewClaimModel
        mItem?.address = address
        mLocation = location
        
        self.editPage.refresh()
    }
    
    func beforeDrawing(_ sender: CustomEditPage) {
        sender.labelWidth = Config.fieldLongLabelWidth
        
        let x = Config.padding
        var y = Config.padding
        let myClaimDetails = ExtraBigLabel(frame: CGRect(x: x, y: y, width: UIScreen.main.bounds.width - x * 2, height: 0)).initView()
        myClaimDetails.numberOfLines = 0
        myClaimDetails.font = UIFont.boldSystemFont(ofSize: Config.fontSizeExtraBig)
        myClaimDetails.textAlignment = .center
        myClaimDetails.text = "My Claim Details"
        var height = myClaimDetails.fitHeight()
        sender.addSubview(myClaimDetails)
        
        y = y + height + Config.lineHeight
        
        let subTitle = CustomLabel(frame: CGRect(x: x, y: y, width: UIScreen.main.bounds.width - x * 2, height: 0)).initView()
        subTitle.numberOfLines = 0
        subTitle.textAlignment = .center
        subTitle.text = "Please fill in your vehicle details and your particulars below"
        height = subTitle.fitHeight()
        sender.addSubview(subTitle)
    }
    
    func afterDrawing(_ sender: CustomEditPage) -> Bool {
        let bounds = UIScreen.main.bounds
        
        let x = Config.padding
        var y = sender.estimateAdjustedRect().size.height + Config.lineHeight
        let width: CGFloat = bounds.width - x * 2
        
        let uploadTitle = ExtraBigLabel(frame: CGRect(x: x, y: y, width: width, height: 0)).initView()
        uploadTitle.numberOfLines = 0
        uploadTitle.font = UIFont.boldSystemFont(ofSize: Config.fontSizeExtraBig)
        uploadTitle.textAlignment = .center
        uploadTitle.text = "Upload Images"
        var height = uploadTitle.fitHeight()
        sender.addSubview(uploadTitle)
        
        y = y + height + Config.lineHeight
        
        let subTitle = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: 0)).initView()
        subTitle.numberOfLines = 0
        subTitle.textAlignment = .center
        subTitle.text = "Please provide sufficient images of your damaged vehicle and other necessary documents."
        height = subTitle.fitHeight()
        sender.addSubview(subTitle)
        
        y = y + height + Config.lineHeight
        
        for item in [PhotoCategory.DamagedVehicle, PhotoCategory.DrivingLicense, PhotoCategory.PoliceReport] {
            let view = drawImageUpload(category: item, left: x, top: y)
            sender.addSubview(view)
            y = y + view.frame.height + Config.lineHeight
        }
        
        return true
    }
    
    func drawImageUpload(category: PhotoCategory, left: CGFloat, top: CGFloat) -> UIView {
        var x = left
        var y = top
        let width: CGFloat = UIScreen.main.bounds.width - x * 2
        let view = UIView(frame: CGRect(x: x, y: y, width: width, height: Config.lineHeight)).initView()
        
        x = 0
        y = 0
        let titleLabel = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: Config.lineHeight)).initView()
        titleLabel.text = "\(category.title):"
        view.addSubview(titleLabel)
        
        y = y + Config.lineHeight + Config.padding
        let imageSize = Config.lineHeight * 4
        let iconSize = Config.iconSizeBig
        
        y = y + imageSize / 2 - iconSize / 2
        
        let btnAdd = CustomImageView(frame: CGRect(x: x, y: y, width: iconSize, height: iconSize)).initView()
        btnAdd.tag = Convert(category.rawValue).to()!
        btnAdd.tintColor = CarfixColor.primary.color
        btnAdd.image = #imageLiteral(resourceName: "ic_add_circle")
        view.addSubview(btnAdd)
        
        let gestureAdd = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
        gestureAdd.delegate = self
        btnAdd.isUserInteractionEnabled = true
        btnAdd.addGestureRecognizer(gestureAdd)
        
        x = x + btnAdd.frame.width + Config.padding
        y = titleLabel.frame.origin.y + titleLabel.frame.size.height + Config.padding
        
        if let images = mImages?[category] {
            for image in images {
                let imageView = CustomImageView(frame: CGRect(x: x, y: y, width: imageSize, height: imageSize)).initView()
                imageView.image = image
                view.addSubview(imageView)
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
                gesture.delegate = self
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(gesture)
                imageView.tag = Convert(category.rawValue).to()!
                
                x = x + imageSize + Config.padding
                if x + imageSize > width {
                    x = btnAdd.frame.origin.x + btnAdd.frame.width + Config.padding
                    y = y + imageSize + Config.padding
                }
            }
        }
        
        view.frame = view.estimateAdjustedRect()
        
        return view
    }
    
    var viewImageCategory: PhotoCategory?
    func viewImage(_ sender: UIGestureRecognizer) {
        if let imageView = sender.view as? CustomImageView {
            if let category = PhotoCategory(rawValue: Convert(imageView.tag).to()!) {
                viewImageCategory = category
                performSegue(withIdentifier: Segue.segueViewImage.rawValue, sender: imageView)
            }
        }
    }
    
    func removeImage(category: PhotoCategory, index: Int) {
        mImages?[category]?.remove(at: index)
        self.editPage.refresh()
    }
    
    func removeExistsImage(category: PhotoCategory, index: Int) {        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: ViewImageController = segue.getMainController() {
            if let imageView = sender as? CustomImageView {
                if let category = viewImageCategory {
                    if let images = getCategoryImages(category: category) {
                        var passImages: [ViewImageController.ViewImageItem] = []
                        for image in images {
                            passImages.append(ViewImageController.ViewImageItem(key: nil, path: nil, image: image))
                        }
                        svc.images = passImages
                        var count = 0
                        for image in images {
                            if image == imageView.image {
                                break
                            }
                            count = count + 1
                        }
                        svc.index = count
                        svc.category = category
                        svc.delegate = self
                    }
                }
            }
        } else if let svc: PanelWorkshopController = segue.getMainController() {
            //            svc.images = self.mImages
            //            svc.newClaimModel = editPage.getResult() as! NewClaimModel
            //            svc.offerService = self.mModel!
            //            svc.location = self.mLocation!
            if let insurerName = self.mModel?.InsurerName ?? self.mModel?.Title {
                svc.insurerName = insurerName
            }
            svc.delegate = self
        } else if let svc: NewClaimMapController = segue.getMainController() {
            svc.delegate = self
        } else if let svc: NewClaimResultController = segue.getMainController()  {
//            svc.companyName = self.mModel?.Title
//            svc.result = mResult ?? NewClaimResult(obj: nil)
            svc.key = mResult?.key
        }
    }
    
    func getCategoryImages(category: PhotoCategory) -> [UIImage]? {
        return mImages?[category]
    }
    
    var photoCategory: PhotoCategory?
    func pickImage(_ sender: UIGestureRecognizer) {
        if let cat: Int16 = Convert(sender.view?.tag).to() {
            photoCategory = PhotoCategory(rawValue: cat)
        }
        self.cameraOrPhoto(sender: self)
    }
    
    func imagePickerPreferredContentSize() -> CGSize {
        return CGSize(width: Config.profileImageWidth, height: Config.profileImageWidth)
    }
    
    var mImages: [PhotoCategory: [UIImage]]?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if mImages.isEmpty {
            mImages = [:]
        }
        
        if let photoCategory = photoCategory {
            if mImages?[photoCategory] == nil {
                let images = [UIImage]()
                mImages?.updateValue(images, forKey: photoCategory)
            }
            
            if let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                mImages![photoCategory]!.append(image)
            } else { print("some error message") }
            
            mItem = self.editPage.getResult() as? NewClaimModel
            self.editPage.refresh()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        if mLocation.isEmpty || mItem?.address?.isEmpty == true {
            self.message(content: "Accident address is required to continue...")
        } else {
            if editPage.validateFields() {
                performSegue(withIdentifier: Segue.seguePanelWorkshops.rawValue, sender: self)
            } else {
                self.message(content: "Please enter required field to continue...")
            }
        }
    }
    
    var mResult: NewClaimResult?
    func returnData(sender: BaseController, item: Any) {
        if let newClaimModel = editPage.getResult() as? NewClaimModel {
            if let selectedRow = item as? PanelWorkshopController.PanelWorkshopItem {
                if let location = self.mLocation {
                    if let insurerName = self.mModel?.InsurerName ?? self.mModel?.Title {
                        self.confirm(content: "Confirm to submit your claim?", handler: { data in                            
                            var imageList = [String: UIImage]()
                            
                            if let images = self.mImages {
                                for item in images {
                                    var count = 0
                                    for image in item.value {
                                        imageList["\(item.key.rawValue);\(count).jpg"] = image
                                        count = count + 1
                                    }
                                }
                            }
                            
                            sender.showProgressBar(msg: "The action might take few minutes to complete, please don’t close the apps until further instruction")
                            
                            let workshop = selectedRow.mModel?.key
                            CarFixAPIPost(self).newClaim(ins: insurerName, vehReg: newClaimModel.vehicleNo!, accidentDate: newClaimModel.accidentDate!, icNo: newClaimModel.icNo!, workshop: workshop, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, accidentLocation: newClaimModel.address!, images: imageList) { data in
                                self.mResult = data?.Result
                                self.performSegue(withIdentifier: Segue.segueNewClaimResult.rawValue, sender: self)
                            }
                        })
                    }
                }
            }
        }
    }
    
    class NewClaimModel: NSObject {
        public var vehicleNo: String?
        public var accidentDate: Date?
        public var address: String?
        public var icNo: String?
        public var mobileNo: String?
        //        5. upload photo - damaged vehicle
        //        6. upload photo - driving license
        //        7. upload photo - police report
    }
}
