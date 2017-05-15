//
//  NewClaimController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NewClaimController: BaseFormController, CustomEditPageDelegate, HasImagePicker, UIGestureRecognizerDelegate, ViewImageControllerDelegate {
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
    
    func buildField(name: String, field: UIView) -> UIView {
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
        }
        
        if name == "accidentDate" || name == "icNo" {
            customField.isRequired = true
        }
        
        return customField
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
        
        for item in EnumManager().array(PhotoCategory.self) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc = segue.destination as? ViewImageController {
            if let imageView = sender as? CustomImageView {
                if let category = viewImageCategory {
                    if let images = getCategoryImages(category: category) {
                        svc.images = images
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
        } else if let svc = segue.destination as? PanelWorkshopController {
            svc.images = self.mImages
            svc.newClaimModel = editPage.getResult() as! NewClaimModel
            svc.offerService = self.mModel!
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
        if editPage.validateFields() {
            performSegue(withIdentifier: Segue.seguePanelWorkshops.rawValue, sender: self)
        } else {
            self.message(content: "Please enter required field to continue...")
        }
    }
    
    class NewClaimModel: NSObject {
        public var vehicleNo: String?
        public var accidentDate: Date?
        public var icNo: String?
        public var mobileNo: String?
        //        5. upload photo - damaged vehicle
        //        6. upload photo - driving license
        //        7. upload photo - police report
    }
}
