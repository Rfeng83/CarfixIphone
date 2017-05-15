//
//  ViewSubmissionController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 15/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ViewSubmissionController: BaseFormController, CustomEditPageDelegate, UIGestureRecognizerDelegate {
    var key: String?
    
    @IBOutlet weak var editPage: CustomEditPage!
    
    var mModel: GetClaimResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let key = key {
            CarFixAPIPost(self).getClaim(key: key) { data in
                self.mModel = data?.Result
                
                self.editPage.refresh()
            }
        }
    }
    
    var mItem: ViewSubmissionModel?
    var mImagesExists: [PhotoCategory: [String]]?
    func buildModel() -> NSObject {
        var item: ViewSubmissionModel
        
        item = ViewSubmissionModel()
        
        if let model = self.mModel {
            item.caseID = model.CaseID
            item.claimStatus = model.ClaimStatus
            item.vehicleNo = model.VehicleNo
            item.accidentDate = model.AccidentDate
            item.icNo = model.ICNo
            item.mobileNo = model.MobileNo
            
            self.mImagesExists = [:]
            if let categories = model.PhotoCategories {
                for category in categories {
                    if let photoCategory = PhotoCategory(rawValue: category.Category) {
                        self.mImagesExists?.updateValue([], forKey: photoCategory)
                        
                        if let images = category.Images {
                            for image in images {
                                self.mImagesExists?[photoCategory]?.append(image.Path!)
                            }
                        }
                    }
                }
            }
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
        let customField = field as! CustomTextField
        //        if name == "accidentDate" {
        //            customField = CustomDateTimePicker(frame: customField.frame).initView()
        //            customField.name = name
        //        } else if name == "mobileNo" {
        //            customField = CustomPhoneField(frame: customField.frame).initView()
        //            customField.name = name
        //            customField.isEnabled = false
        //        } else if name == "vehicleNo" {
        //            customField.isEnabled = false
        //        }
        //
        //        if name == "accidentDate" || name == "icNo" {
        //            customField.isRequired = true
        //        }
        
        customField.isEnabled = false
        return customField
    }
    
    func beforeDrawing(_ sender: CustomEditPage) {
        sender.labelWidth = Config.fieldLongLabelWidth
        
        let x = Config.padding
        let y = Config.padding
        let myClaimDetails = ExtraBigLabel(frame: CGRect(x: x, y: y, width: UIScreen.main.bounds.width - x * 2, height: 0)).initView()
        myClaimDetails.numberOfLines = 0
        myClaimDetails.font = UIFont.boldSystemFont(ofSize: Config.fontSizeExtraBig)
        myClaimDetails.textAlignment = .center
        myClaimDetails.text = "My Claim Details"
        _ = myClaimDetails.fitHeight()
        sender.addSubview(myClaimDetails)
        
        //        y = y + height + Config.lineHeight
        //
        //        let subTitle = CustomLabel(frame: CGRect(x: x, y: y, width: UIScreen.main.bounds.width - x * 2, height: 0)).initView()
        //        subTitle.numberOfLines = 0
        //        subTitle.textAlignment = .center
        //        subTitle.text = "Please fill in your vehicle details and your particulars below"
        //        height = subTitle.fitHeight()
        //        sender.addSubview(subTitle)
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
        uploadTitle.text = "Uploaded Images"
        let height = uploadTitle.fitHeight()
        sender.addSubview(uploadTitle)
        
        y = y + height + Config.lineHeight
        
        //        let subTitle = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: 0)).initView()
        //        subTitle.numberOfLines = 0
        //        subTitle.textAlignment = .center
        //        subTitle.text = "Please provide sufficient images of your damaged vehicle and other necessary documents."
        //        height = subTitle.fitHeight()
        //        sender.addSubview(subTitle)
        //
        //        y = y + height + Config.lineHeight
        
        for item in EnumManager().array(PhotoCategory.self) {
            let view = drawImageUpload(category: item, left: x, top: y)
            sender.addSubview(view)
            y = y + view.frame.height + Config.lineHeight
        }
        
        return true
    }
    
    var viewDamagedVehicle: UIView?
    var viewDrivingLicense: UIView?
    var viewPoliceReport: UIView?
    
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
        //        let iconSize = Config.iconSizeBig
        
        //        y = y + imageSize / 2 - iconSize / 2
        //
        //        let btnAdd = CustomImageView(frame: CGRect(x: x, y: y, width: iconSize, height: iconSize)).initView()
        //        btnAdd.tag = Convert(category.rawValue).to()!
        //        btnAdd.tintColor = CarfixColor.primary.color
        //        btnAdd.image = #imageLiteral(resourceName: "ic_add_circle")
        //        view.addSubview(btnAdd)
        
        //        let gestureAdd = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
        //        gestureAdd.delegate = self
        //        btnAdd.isUserInteractionEnabled = true
        //        btnAdd.addGestureRecognizer(gestureAdd)
        
        //        x = x + btnAdd.frame.width + Config.padding
        y = titleLabel.frame.origin.y + titleLabel.frame.size.height + Config.padding
        
        if let images = mImagesExists?[category] {
            for image in images {
                let imageView = CustomImageView(frame: CGRect(x: x, y: y, width: imageSize, height: imageSize)).initView()
                //                imageView.image = image
                view.addSubview(imageView)
                ImageManager.downloadImage(mUrl: image, imageView: imageView)
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
                gesture.delegate = self
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(gesture)
                imageView.tag = Convert(category.rawValue).to()!
                
                x = x + imageSize + Config.padding
                if x + imageSize > width {
                    x = Config.padding
                    y = y + imageSize + Config.padding
                }
            }
        }
        
        view.frame = view.estimateAdjustedRect()
        
        switch category {
        case .DamagedVehicle:
            viewDamagedVehicle = view
        case .DrivingLicense:
            viewDrivingLicense = view
        case .PoliceReport:
            viewPoliceReport = view
        }
        
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
                    }
                }
            }
        }
    }
    
    func getCategoryImages(category: PhotoCategory) -> [UIImage]? {
        var view: UIView?
        switch category {
        case .DamagedVehicle:
            view = self.viewDamagedVehicle
        case .DrivingLicense:
            view = self.viewDrivingLicense
        case .PoliceReport:
            view = self.viewPoliceReport
        }
        
        var images = [UIImage]()
        var count = 0
        if let view = view {
            for subview in view.subviews {
                if count > 0 {
                    if let imageView = subview as? CustomImageView {
                        if let image = imageView.image {
                            images.append(image)
                        }
                    }
                }
                
                count = count + 1
            }
        }
        return images
    }
    
    @IBAction func next(_ sender: Any) {
        self.close(sender: self)
    }
    
    class ViewSubmissionModel: NSObject {
        public var caseID: Int32?
        public var claimStatus: String?
        public var vehicleNo: String?
        public var accidentDate: Date?
        public var icNo: String?
        public var mobileNo: String?
    }
}
