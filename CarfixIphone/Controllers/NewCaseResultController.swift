//
//  NewCaseResultController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NewCaseResultController: BaseTableController {
    var logData: LogCaseResult?
    var mIsPolicyMatched: Bool!
    
    @IBOutlet weak var imgLogo: RoundedImageView!
    @IBOutlet weak var lblTitle: BigLabel!
    @IBOutlet weak var lblCaseID: CustomLabel!
    @IBOutlet weak var lblDescription: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLine
        self.view.backgroundColor = .white
    }
    
    override func buildItems() -> [BaseTableItem]? {
        var items = [BaseTableItem]()
        
        var showFooter = false
        
        if let logData = self.logData {
            if logData.MatchedPolicies != nil && logData.MatchedPolicies!.count > 0 {
                mIsPolicyMatched = true
                
                for item in logData.MatchedPolicies! {
                    items.append(Policy(item))
                }
                if logData.MatchedPolicies!.count == 1 {
                    //items.append(Policy(nil))
                    
                    if let logo = logData.MatchedPolicies?[0].Logo {
                        ImageManager.downloadImage(mUrl: logo, imageView: imgLogo)
                    }
                    
                    lblTitle.text = "Request Submitted"
                    lblDescription.text = "You have successfully submitted your request. One of our friendly operator will contact you at \(logData.PhoneNo!) shortly."
                    lblCaseID.text = "Case ID: \(logData.CaseNo!)"
                    
                    showFooter = true
                } else {
                    imgLogo.image = #imageLiteral(resourceName: "ic_check_circle").withRenderingMode(.alwaysTemplate)
                    imgLogo.tintColor = CarfixColor.green.color
                    
                    lblTitle.text = "Policy Found"
                    lblDescription.text = "Please select a policy to continue"
                    lblCaseID.text = ""
                }
            } else if logData.GeneralHelps != nil && logData.GeneralHelps!.count > 0 {
                mIsPolicyMatched = false;
                //items.append(Policy(nil));
                for item in logData.GeneralHelps! {
                    items.append(Policy(item))
                }
                
                imgLogo.image = #imageLiteral(resourceName: "ic_cancel").withRenderingMode(.alwaysTemplate)
                imgLogo.tintColor = CarfixColor.primary.color
                
                lblTitle.text = "Policy Not Found"
                lblDescription.text = "Your vehicle number is not listed or updated in our list of panels. If you still wish to request for this service, please contact us at:"
                lblCaseID.text = "Case ID: \(logData.Passcode!)"
                
                if !logData.Key.isEmpty {
                    showFooter = true
                }
            }
        }
        
        if showFooter {
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 49))
            
            let continueButton = CustomButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 49, width: UIScreen.main.bounds.width, height: 49)).initView()
            continueButton.setTitle("Continue", for: .normal)
            self.navigationController?.view.addSubview(continueButton)
            
            continueButton.addTarget(self, action: #selector(NewCaseResultController.done), for: .touchUpInside)
        }
        
        return items
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = getItems()?[indexPath.row] as? Policy {
            if let logData = logData {
                if mIsPolicyMatched && logData.MatchedPolicies != nil && logData.MatchedPolicies!.count > 1 {
                    confirm(content: "You have selected the policy by \(item.title!)", handler: {
                        data in
                        
                        if let logData = self.logData {
                            CarFixAPIPost(self).logCase(vehReg: logData.VehReg!, serviceNeeded: Convert(logData.ServiceNeeded).to()!, address: logData.Address!, latitude: Convert(logData.Latitude).to()!, longitude: Convert(logData.Longitude).to()!, vehModel: logData.VehModel!, policyID: Convert(item.policyID).to()!, onSuccess: { data in
                                
                                self.logData = data?.Result
                                
                                self.refresh(sender: self)
                            })
                        }
                    })
                } else {
                    self.confirm(content: "Call \(item.title!)?", handler: {
                        data in
                        
                        if let url = URL(string: "tel://\(item.details!)") {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                // Fallback on earlier versions
                                 UIApplication.shared.openURL(url)
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.lineHeight * 2 + Config.padding * 2
    }
    
    class Policy: BaseTableItem {
        var policyID: NSNumber?
        
        required init(_ model: LogCasePolicyItem?) {
            super.init()
            
            if let item = model {
                self.policyID = item.PolicyID;
                if let logo = item.Logo {
                    self.leftImagePath = logo
                } else {
                    self.leftImage = #imageLiteral(resourceName: "ic_appicon")
                }
                self.title = item.SubscriberName;
                self.details = item.Hotline;
            }
            else {
                self.leftImage = #imageLiteral(resourceName: "ic_appicon")
                
                let carFixInfo = CarfixInfo()
                let profile = carFixInfo.profile
                self.title = "Carfix \(Country.from(code: profile.countryCode)!.rawValue)"
                self.details = carFixInfo.getCarfixContact()
            }
        }
    }
}

class PolicyTableViewCell: CustomTableViewCell {
    override func initView() -> PolicyTableViewCell {
        _ = super.initView()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        var x = margin + padding
        var y = padding
        let imageWidth: CGFloat = Config.lineHeight * 2
        
        self.leftImage.frame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
        self.leftImage.contentMode = .scaleAspectFit
        //self.leftImage.tintColor = .white
        
        let rightImageX = screenSize.width - imageWidth - margin - padding
        let rightImage = RoundedImageView(frame: CGRect(x: padding, y: padding, width: imageWidth - padding * 2, height: imageWidth - padding * 2)).initView()
        rightImage.tintColor = CarfixColor.white.color
        rightImage.image = #imageLiteral(resourceName: "ic_phone").withRenderingMode(.alwaysTemplate)
        
        let rightImageBackground = RoundedView(frame: CGRect(x: rightImageX, y: y, width: imageWidth, height: imageWidth)).initView()
        rightImageBackground.backgroundColor = CarfixColor.primary.color
        rightImageBackground.addSubview(rightImage);
        
        self.addSubview(rightImageBackground)
        
        x = x + imageWidth + margin
        
        let width = screenSize.width - x - (screenSize.width - rightImageX)
        let height: CGFloat = Config.lineHeight
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        y = y + height
        
        x = x + width + margin
        
        return self
    }
}
