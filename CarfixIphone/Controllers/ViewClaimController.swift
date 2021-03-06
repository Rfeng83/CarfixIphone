//
//  ViewClaimController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 12/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ViewClaimController: BaseFormController, HasImagePicker, UIGestureRecognizerDelegate, ViewImageControllerDelegate {
    @IBOutlet weak var imgLogo: CustomImageView!
    @IBOutlet weak var labelCaseID: CustomLabel!
    @IBOutlet weak var labelClaimStatus: CustomLabel!
    @IBOutlet weak var labelApprovalAmount: CustomLabel!
    
    @IBOutlet weak var viewDamagedVehicle: UIView!
    @IBOutlet weak var viewDamagedVehicleHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDrivingLicense: UIView!
    @IBOutlet weak var viewDrivingLicenseHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPoliceReport: UIView!
    @IBOutlet weak var viewPoliceReportHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnUpload: CustomButton!
    @IBOutlet weak var btnViewApprovalLetter: CustomButton!
    @IBOutlet weak var btnViewDischargeVoucher: CustomButton!
    
    var key: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    var mModel: GetClaimResult?
    func refresh() {
        CarFixAPIPost(self).getClaim(key: key!) { data in
            self.mModel = data?.Result
            
            if let model = self.mModel {
                if let image = model.InsurerImage {
                    ImageManager.downloadImage(mUrl: image, imageView: self.imgLogo)
                }
                
                self.labelCaseID.text = "\(model.CaseID)"
                self.labelClaimStatus.text = model.ClaimStatus
                self.labelApprovalAmount.text = Convert(model.ApprovalAmount ?? 0).toCurrency()
                
                self.btnViewApprovalLetter.isEnabled = model.IsApproved == 1
                self.btnViewDischargeVoucher.isEnabled = model.IsApproved == 1
                
                self.mImagesExists = [:]
                
                self.drawImageUpload(category: .DamagedVehicle)
                self.drawImageUpload(category: .DrivingLicense)
                self.drawImageUpload(category: .PoliceReport)
            }
        }
    }
    
    func drawImageUpload(category: PhotoCategory) {
        var view: UIView!
        var heightConstraint: NSLayoutConstraint!
        switch category {
        case .DamagedVehicle:
            view = viewDamagedVehicle
            heightConstraint = viewDamagedVehicleHeight
        case .DrivingLicense:
            view = viewDrivingLicense
            heightConstraint = viewDrivingLicenseHeight
        case .PoliceReport:
            view = viewPoliceReport
            heightConstraint = viewPoliceReportHeight
        default:
            return
        }
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        let width: CGFloat = view.bounds.width - x * 2
        
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
        y = 0
        
        if let images = mImagesExists?[category] {
            var passImages = [String: UIImage?]()
            for image in images {
                passImages.updateValue(nil, forKey: image)
            }
            let point = drawImages(view: view, category: category, images: passImages, btnAdd: btnAdd, left: x, top: y, width: width, imageSize: imageSize)
            x = point.x
            y = point.y
        }
        
        if let images = mImages?[category] {
            var passImages = [String: UIImage?]()
            var count = 0
            for image in images {
                passImages.updateValue(image, forKey: "\(count)")
                count = count + 1
            }
            let point = drawImages(view: view, category: category, images: passImages, btnAdd: btnAdd, left: x, top: y, width: width, imageSize: imageSize)
            x = point.x
            y = point.y
        }
        
        heightConstraint.constant = view.estimateAdjustedRect().height
        
        btnUpload.isEnabled = false
        if let images = mImages {
            for image in images {
                if image.value.count > 0 {
                    btnUpload.isEnabled = true
                    break
                }
            }
        }
    }
    
    @IBAction func uploadImages(_ sender: Any) {
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
        
        self.showProgressBar(msg: "The action might take few minutes to complete, please don’t close the apps until further instruction")
        
        if let key = key {
            CarFixAPIPost(self).uploadClaimPhotos(key: key, message: nil, images: imageList) { data in
                self.performSegue(withIdentifier: Segue.segueViewSubmission.rawValue, sender: self)
                self.mImages = [:]
                self.refresh()
            }
        }
    }
    
    func drawImages(view: UIView, category: PhotoCategory, images: [String: UIImage?], btnAdd: CustomImageView, left: CGFloat, top: CGFloat, width: CGFloat, imageSize: CGFloat) -> CGPoint {
        var x = left
        var y = top
        
        for (path, image) in images {
            let imageView = CustomImageView(frame: CGRect(x: x, y: y, width: imageSize, height: imageSize)).initView()
            if let image = image {
                imageView.image = image.compressed
                imageView.tag = Convert(category.rawValue).to()!
            } else {
                ImageManager.downloadImage(mUrl: path, imageView: imageView)
                imageView.tag = 0
            }
            view.addSubview(imageView)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(viewImage(sender:)))
            gesture.delegate = self
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(gesture)
            
            x = x + imageSize + Config.padding
            if x + imageSize > width {
                x = btnAdd.frame.origin.x + btnAdd.frame.width + Config.padding
                y = y + imageSize + Config.padding
            }
        }
        
        return CGPoint(x: x, y: y)
    }
    
    var viewImageCategory: PhotoCategory?
    func viewImage(sender: UIGestureRecognizer) {
        if let imageView = sender.view as? CustomImageView {
            if let category = PhotoCategory(rawValue: Convert(imageView.tag).to()!) {
                viewImageCategory = category
                performSegue(withIdentifier: Segue.segueViewImage.rawValue, sender: imageView)
            }
        }
    }
    
    var titleApprovalLetter = "Approval Letter"
    @IBAction func viewApprovalLetter(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: titleApprovalLetter)
    }
    
    var titleDischargeVoucher = "Discharge Voucher"
    @IBAction func viewDischargeVoucher(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: titleDischargeVoucher)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc = segue.destination as? ViewImageController {
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
                        if let count = mImagesExists?.count {
                            svc.indexCanRemove = count
                        }
                        svc.category = category
                        svc.delegate = self
                    }
                    
                }
            }
        } else if let svc = segue.destination as? ViewSubmissionController {
            svc.key = self.key
        } else if let nav = segue.destination as? UINavigationController {
            if let svc = nav.topViewController as? WebController {
                if let title = sender as? String {
                    svc.title = title
                    var uri: URL?
                    
                    if title.compare(titleApprovalLetter) == .orderedSame {
                        if let url = self.mModel?.ApprovalLetterUrl {
                            uri = URL(string: url)
                        }
                    } else if title.compare(titleDischargeVoucher) == .orderedSame {
                        if let url = self.mModel?.DischargeVoucherUrl {
                            uri = URL(string: url)
                        }
                    }
                    
                    if let uri = uri {
                        let queryItems = [URLQueryItem(name: "embedded", value: "true"), URLQueryItem(name: "url", value: uri.absoluteString)]
                        var urlComps = URLComponents(string: "http://drive.google.com/viewerng/viewer")!
                        urlComps.queryItems = queryItems
                        svc.url = urlComps.url
                    }
                }
            }
        }
    }
    
    func getCategoryImages(category: PhotoCategory) -> [UIImage]? {
        var view: UIView!
        switch category {
        case .DamagedVehicle:
            view = self.viewDamagedVehicle
        case .DrivingLicense:
            view = self.viewDrivingLicense
        case .PoliceReport:
            view = self.viewPoliceReport
        default:
            return []
        }
        
        var images = [UIImage]()
        var count = 0
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
        return images
    }
    
    func removeImage(category: PhotoCategory, index: Int) {
        mImages?[category]?.remove(at: index)
        drawImageUpload(category: category)
    }
    
    func removeExistsImage(category: PhotoCategory, index: Int) {
        mImagesExists?[category]?.remove(at: index)
        drawImageUpload(category: category)
    }
    
    var photoCategory: PhotoCategory?
    func pickImage(_ sender: UIGestureRecognizer) {
        if let cat: Int16 = Convert(sender.view?.tag).to() {
            photoCategory = PhotoCategory(rawValue: cat)
        }
        self.cameraOrPhoto(sender: self, allowsEditing: false)
    }
    
    func imagePickerPreferredContentSize() -> CGSize {
        return CGSize(width: Config.profileImageWidth, height: Config.profileImageWidth)
    }
    
    var mImagesExists: [PhotoCategory: [String]]?
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
            
            if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                mImages![photoCategory]!.append(image)
            } else { print("some error message") }
            
            self.drawImageUpload(category: photoCategory)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
