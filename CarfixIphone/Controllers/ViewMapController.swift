//
//  NewCaseController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 16/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

class ViewMapController: BaseFormController, GMSMapViewDelegate {
    var key: String!
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        CarFixAPIPost(self).getCaseDetails(key: key, onSuccess: { data in
            if let result = data?.Result {
                let latitude: CLLocationDegrees = Convert(result.Latitude ?? 3.114334).to()!
                let longitude: CLLocationDegrees = Convert(result.Longitude ?? 101.180573).to()!
                
//                //rfeng: remove this later
//                latitude = latitude - 0.01
//                longitude = longitude - 0.02
                
                let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: self.zoomLevel)
                
                self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapContainer.bounds.width, height: self.mapContainer.bounds.height), camera: camera)
                self.mapView.isMyLocationEnabled = false
                self.mapView.settings.myLocationButton = false
                
                self.mapContainer.addSubview(self.mapView)
                
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
}
