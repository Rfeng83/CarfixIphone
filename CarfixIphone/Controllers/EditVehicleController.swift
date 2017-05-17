//
//  EditVehicleController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class EditVehicleController: BaseFormController, CustomEditPageDelegate, HasImagePicker, PopupPickerDelegate {
    var key: String?
    
    @IBOutlet weak var editPage: CustomEditPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = key {
            CarFixAPIPost(self).getVehicles(key: id, onSuccess: { data in
                self.mModel = nil
                
                if let result = data?.Result {
                    if let item = result.first {
                        self.mModel = item
                        self.editPage.refresh()
                        
                        self.loadPickerOptions(picker: self.brandPicker)
                        self.loadPickerOptions(picker: self.modelPicker)
                        self.loadPickerOptions(picker: self.engineCCPicker)
                        self.loadPickerOptions(picker: self.transmissionPicker)
                        self.loadPickerOptions(picker: self.variantSeriesPicker)
                    }
                }
            })
        }
    }
    
    var mModel: GetVehiclesResult?
    func buildModel() -> NSObject {
        if let model = self.mModel {
            let vehicleModel = VehicleModel()
            vehicleModel.vehicleNo = model.VehicleRegNo
            vehicleModel.brand = model.Brand
            vehicleModel.model = model.Model
            vehicleModel.year = model.VehYear
            vehicleModel.engineCC = model.EngineCC
            vehicleModel.transmission = model.Transmission
            vehicleModel.variantSeries = model.Variant
            
            return vehicleModel
        } else {
            return VehicleModel()
        }
    }
    
    var yearPicker: PopupPicker!
    var brandPicker: PopupPicker!
    var modelPicker: PopupPicker!
    var engineCCPicker: PopupPicker!
    var transmissionPicker: PopupPicker!
    var variantSeriesPicker: PopupPicker!
    func buildField(name: String, item: BaseTableItem, field: UIView) -> UIView {
        var customField = field as! CustomTextField
        if name == "year" {
            yearPicker = PopupPicker(frame: field.frame).initView()
            let array = NSMutableArray()
            let year = Calendar.current.component(.year, from: Date())
            for f in sequence(first: year, next: { $0 - 1 })
                .prefix(50) {
                    array.add(f)
            }
            yearPicker.setPickOption(arr: array)
            customField = yearPicker
            customField.isRequired = true
        } else if name == "brand" {
            brandPicker = PopupPicker(frame: field.frame).initView()
            customField = brandPicker
            customField.isRequired = true
        } else if name == "model" {
            modelPicker = PopupPicker(frame: field.frame).initView()
            customField = modelPicker
        } else if name == "variantSeries" {
            variantSeriesPicker = PopupPicker(frame: field.frame).initView()
            customField = variantSeriesPicker
        } else if name == "transmission" {
            transmissionPicker = PopupPicker(frame: field.frame).initView()
            customField = transmissionPicker
        } else if name == "engineCC" {
            engineCCPicker = PopupPicker(frame: field.frame).initView()
            customField = engineCCPicker
        } else if name == "vehicleNo" {
            customField.autocapitalizationType = .allCharacters
            customField.isRequired = true
        }
        return customField
    }
    
    func didSelectRow(_ picker: PopupPicker) {
        var effectPicker: PopupPicker?
        if picker == yearPicker {
            effectPicker = brandPicker
        } else if picker == brandPicker {
            effectPicker = modelPicker
        } else if picker == modelPicker {
            effectPicker = engineCCPicker
        } else if picker == engineCCPicker {
            effectPicker = transmissionPicker
        } else if picker == transmissionPicker {
            effectPicker = variantSeriesPicker
        }
        
        let pickers = [yearPicker, brandPicker, modelPicker, engineCCPicker, transmissionPicker, variantSeriesPicker]
        var pickerMatched = false
        for item in pickers {
            if pickerMatched {
                item?.selectRow("")
            }
            if picker == item {
                pickerMatched = true
            }
        }
        
        loadPickerOptions(picker: effectPicker)
    }
    
    func loadPickerOptions(picker: PopupPicker?) {
        if let model = editPage.getResult() as? VehicleModel {
            let onSuccess: (GetSelectListItemsResponse?) -> Void = { data in
                if let result = data?.Result {
                    let arr = NSMutableArray()
                    for item in result {
                        if let value = item.Value {
                            arr.add(value)
                        }
                    }
                    picker?.setPickOption(arr: arr)
                }
            }
            
            if picker == brandPicker {
                if model.year.isEmpty == false {
                    MobileUserAPI(self).getMakeItems(year: Convert(model.year).to()!, onSuccess: onSuccess)
                    return
                }
            } else if picker == modelPicker {
                if model.year.isEmpty == false && model.brand.isEmpty == false {
                    MobileUserAPI(self).getModelItems(year: Convert(model.year).to()!, make: model.brand!, onSuccess: onSuccess)
                    return
                }
            } else if picker == engineCCPicker {
                if model.year.isEmpty == false && model.brand.isEmpty == false && model.model.isEmpty == false {
                    MobileUserAPI(self).getEngineCCItems(year: Convert(model.year).to()!, make: model.brand!, model: model.model!, onSuccess: onSuccess)
                    return
                }
            } else if picker == transmissionPicker {
                if model.year.isEmpty == false && model.brand.isEmpty == false && model.model.isEmpty == false && model.engineCC.isEmpty == false {
                    MobileUserAPI(self).getTransmissionItems(year: Convert(model.year).to()!, make: model.brand!, model: model.model!, cc: model.engineCC!, onSuccess: onSuccess)
                    return
                }
            } else if picker == variantSeriesPicker {
                if model.year.isEmpty == false && model.brand.isEmpty == false && model.model.isEmpty == false && model.engineCC.isEmpty == false && model.transmission.isEmpty == false {
                    MobileUserAPI(self).getVariantSeriesItems(year: Convert(model.year).to()!, make: model.brand!, model: model.model!, cc: model.engineCC!, trmsn: model.transmission!, onSuccess: onSuccess)
                    return
                }
            }
            
            picker?.setPickOption(arr: [])
        }
    }
    
    var vehicleImage: RoundedImageView!
    
    func beforeDrawing(_ sender: CustomEditPage) {
        sender.labelWidth = Config.fieldLongLabelWidth
        
        let bounds = UIScreen.main.bounds
        let width: CGFloat = 128
        let height: CGFloat = width
        let x: CGFloat = (bounds.width - width) / 2
        let y: CGFloat = 10
        
        let imageView = RoundedImageView(frame: CGRect(x: x, y: y, width: width, height: height)).initView()
        if let imagePath = mModel?.Image {
            ImageManager.downloadImage(mUrl: imagePath, imageView: imageView)
        } else {
            imageView.image = #imageLiteral(resourceName: "ic_vehicle_default")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(imageTapped(img:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        vehicleImage = imageView
        
        sender.insertSubview(imageView, at: 0)
        
        
    }
    
    func afterDrawing(_ sender: CustomEditPage) -> Bool {
        let mandatoryLabel = SmallLabel(frame: CGRect(x: Config.padding, y: sender.estimateAdjustedRect().size.height + Config.padding, width: UIScreen.main.bounds.size.width, height: Config.lineHeight)).initView()
        let text: NSMutableAttributedString = NSMutableAttributedString.init(string: "* - mandatory fields")
        text.addAttributes([NSForegroundColorAttributeName: CarfixColor.primary.color], range: NSMakeRange(0, 1))
        mandatoryLabel.attributedText = text
        
        sender.addSubview(mandatoryLabel)
        
        
        let mycarInfoLabel = SmallLabel(frame: CGRect(x: Config.padding, y: sender.estimateAdjustedRect().size.height + Config.padding, width: UIScreen.main.bounds.size.width - 20, height: Config.lineHeight * 2)).initView()
        mycarInfoLabel.textAlignment = NSTextAlignment.center
        mycarInfoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        mycarInfoLabel.numberOfLines = 2
        let mycarInfoText: NSMutableAttributedString = NSMutableAttributedString.init(string: "Complete the above details to get your estimated vehicle market value.")
        //        mycarInfoText.addAttributes([NSForegroundColorAttributeName: CarfixColor.primary.color], range: NSMakeRange(0, mycarInfoText.length - 1))
        mycarInfoLabel.attributedText = mycarInfoText
        sender.addSubview(mycarInfoLabel)

        
        
        let bounds = UIScreen.main.bounds
        let width: CGFloat = 128
        let x: CGFloat = (bounds.width - width) / 2
        
        let ivMyCarInfo = CustomImageView(frame: CGRect(x: x, y: sender.estimateAdjustedRect().size.height + Config.padding, width: 108, height: 44)).initView()
        
        ivMyCarInfo.image = #imageLiteral(resourceName: "img_mycarinfo_color")
        sender.addSubview(ivMyCarInfo)
        
        
        
        return true
    }
    
    func imageTapped(img: RoundedImageView) {
        self.cameraOrPhoto(sender: img)
    }
    
    func imagePickerPreferredContentSize() -> CGSize {
        return CGSize(width: Config.profileImageWidth, height: Config.profileImageWidth)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var myImageName: String
        
        let uuid = NSUUID()
        myImageName = uuid.uuidString + ".JPEG"
        
        if let imagePath = ImageManager.fileInDocumentsDirectory(filename: myImageName) {
            if let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                if ImageManager.saveImage(image: image, path: imagePath.absoluteString) {
                    loadImage(path: myImageName)
                } else {
                    print("failed to save image")
                }
            } else { print("some error message") }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var newImagePath: String?
    func loadImage(path: String){
        newImagePath = path
        vehicleImage?.image = ImageManager.loadImageFromPath(path: ImageManager.fileInDocumentsDirectory(filename: path)?.path)
    }
    
    @IBAction func save(_ sender: Any) {
        if editPage.validateFields() {
            if let model = editPage.getResult() as? VehicleModel {
                if model.year.isEmpty == false && model.brand.isEmpty == false && model.model.isEmpty == false && model.engineCC.isEmpty == false && model.transmission.isEmpty == false && model.variantSeries.isEmpty == false {
                    MobileUserAPI(self).getVehicles(year: Convert(model.year).to()!, make: model.brand!, model: model.model!, cc: model.engineCC!, trmsn: model.transmission!, varser: model.variantSeries!, onSuccess: { data in
                        if let result = data?.Result?.first {
                            self.confirmSave(model: model, nvic: result.NVIC)
                        }
                    })
                }
                else {
                    self.confirmSave(model: model, nvic: nil)
                }
            }
        } else {
            self.message(content: "Please enter required data to continue")
        }
    }
    
    func confirmSave(model: VehicleModel, nvic: String?) {
        let isDefault: Int32? = Convert(mModel?.IsDefault).to()
        
        CarFixAPIPost(self).updateVehicle(key: self.key, vehicleRegNo: model.vehicleNo!, brand: model.brand, model: model.model!, year: Convert(model.year).to(), cc: model.engineCC, trmsn: model.transmission, varser: model.variantSeries, nvic: nvic, isDefault: isDefault ?? 0, policyEffDate: nil, policyExpDate: nil, onSuccess: { data in
            
            if let result = data?.Result {
                if let key = result.key {
                    if let imagePath = self.newImagePath {
                        let imageUrl = ImageManager.fileInDocumentsDirectory(filename: imagePath)!
                        let imageForUpload = ImageManager.loadImageFromPath(path: imageUrl.path)!
                        
                        CarFixAPIPost(self).uploadImages(folder: "Vehicles", key: key, images: ["\(key).jpg" : imageForUpload], onSuccess: { data in
                            
                            if !ImageManager.deleteImage(path: imagePath) {
                                print("Failed to delete image from devices")
                            }
                            
                            if let downloadPath = data?.Result?.downloadPath {
                                ImageManager.downloadImage(mUrl: downloadPath, imageView: self.vehicleImage, cache: false, onSuccess: { data in
                                    
                                    self.message(content: "Save Successfully", dismissView: true)
                                })
                            }
                        })
                    }
                    else {
                        self.message(content: "Save Successfully", dismissView: true)
                    }
                }
            }
        })
    }
    
    class VehicleModel: NSObject {
        var vehicleNo: String?
        var year: NSNumber?
        var brand: String?
        var model: String?
        var engineCC: String?
        var transmission: String?
        var variantSeries: String?
    }
}
