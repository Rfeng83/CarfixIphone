//
//  CaseHistoryDetailsController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 06/04/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class CaseHistoryDetailsController: BaseFormController, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var key: String!
    
    @IBOutlet weak var panelInfo: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusProgressBar: CustomImageView!
    @IBOutlet weak var imgVehicle: RoundedImageView!
    @IBOutlet weak var txtAccidentDate: CustomLabel!
    @IBOutlet weak var txtServiceNeeded: CustomLabel!
    
    @IBOutlet weak var txtCaseID: CustomLabel!
    @IBOutlet weak var txtTruckNo: CustomLabel!
    @IBOutlet weak var txtDriverName: CustomLabel!
    
    @IBOutlet weak var panelPolicy: UIView!
    @IBOutlet weak var imgInsuranceHeight: NSLayoutConstraint!
    @IBOutlet weak var imgInsurance: UIImageView!
    @IBOutlet weak var txtInsuranceName: CustomLabel!
    @IBOutlet weak var txtPolicyDue: SmallLabel!
    @IBOutlet weak var txtCharges: CustomLabel!
    @IBOutlet weak var txtChargesLabel: SmallLabel!
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    var logData: [GetCaseDetailsLogData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panelInfo.backgroundColor = CarfixColor.gray100.color
        
        imgInsuranceHeight.constant = panelPolicy.frame.size.height - 8
        CarFixAPIPost(self).getCaseDetails(key: key, onSuccess: { data in
            if let result = data?.Result {
                self.logData = result.data
                self.tableView.reloadData()
                
                switch result.CaseStatus {
                case 2:
                    self.statusProgressBar.image = #imageLiteral(resourceName: "img_progress_2")
                    break
                case 3:
                    self.statusProgressBar.image = #imageLiteral(resourceName: "img_progress_3")
                    break
                default:
                    self.statusProgressBar.image = #imageLiteral(resourceName: "img_progress_1")
                    break
                }
                
                if result.ImageUrl.isEmpty || result.ImageUrl == "" {
                    self.imgVehicle.image = #imageLiteral(resourceName: "ic_vehicle_default")
                } else {
                    ImageManager.downloadImage(mUrl: result.ImageUrl!, imageView: self.imgVehicle)
                }
                
                if result.InsImageURL.isEmpty || result.InsImageURL == "" {
                    self.imgInsurance.image = ImageManager.RBResizeImage(image: #imageLiteral(resourceName: "ic_vehicle_default"), targetSize: self.imgInsurance.frame.size)
                } else {
                    ImageManager.downloadImage(mUrl: result.InsImageURL!, imageView: self.imgInsurance)
                }
                
                self.txtAccidentDate.text = Convert(result.CreatedDate).to()
                self.txtServiceNeeded.text = ServiceNeeded(rawValue: result.ServiceNeeded)?.title ?? ServiceNeeded.TowingServices.title
                
                //self.txtETA.text = result.ArrivedTime?.forDisplay() ?? " "
                self.txtCaseID.text = result.Passcode ?? " "
                self.txtTruckNo.text = result.TruckNo ?? " "
                self.txtDriverName.text = result.DriverName ?? " "
                self.txtInsuranceName.text = result.InsuranceName ?? "No policy found"
                self.txtPolicyDue.text = result.PolicyDue ?? " "
                
                self.txtCharges.text = " "
                self.txtChargesLabel.text = " "
                
                let latitude: CLLocationDegrees = Convert(result.Latitude ?? 3.114334).to()!
                let longitude: CLLocationDegrees = Convert(result.Longitude ?? 101.180573).to()!
                
                let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: self.zoomLevel)
                
                self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.mapContainer.bounds.height), camera: camera)
                
                self.mapView.delegate = self
                
                self.mapContainer.insertSubview(self.mapView, at: 0)
                self.mapContainer.isUserInteractionEnabled = true
                let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openMapView (_:)))
                self.mapContainer.addGestureRecognizer(gesture)
                self.mapView.isUserInteractionEnabled = false
                
                let end: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                //                result.TruckLatitude = 3.08074194
                //                result.TruckLongitude = 101.68983800
                
                if !result.TruckLatitude.isEmpty && !result.TruckLongitude.isEmpty && !result.Latitude.isEmpty && !result.Longitude.isEmpty {
                    
                    let start: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Convert(result.TruckLatitude).to()!, longitude: Convert(result.TruckLongitude).to()!)
                    
                    MapManager(self.mapView).getDirections(start: start, end: end)
                } else {
                    let dmarker = GMSMarker()
                    dmarker.position = end
                    dmarker.icon = #imageLiteral(resourceName: "ic_location")
                    dmarker.map = self.mapView
                }
            }
        })
    }
    
    func openMapView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueViewMap.rawValue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? ViewMapController {
                vc.key = self.key
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.logData {
            return items.count
        }
        return 0
    }
    
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        
        if let item = self.logData?[indexPath.row] {
            cell.textLabel?.text = item.LogDate?.forDisplay()
            cell.textLabel?.font = Config.fontSmall
            if let message = item.Message {
                cell.detailTextLabel?.text = "- \(message)"
                cell.detailTextLabel?.font = Config.fontSmall
            }
        }
        
        return cell
    }
    
}
