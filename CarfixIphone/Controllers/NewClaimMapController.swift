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

class NewClaimMapController: BaseFormController, GMSMapViewDelegate, CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    var delegate: NewClaimMapControllerDelegate?
    
    @IBOutlet weak var mapViewContainer: UIView!
    var mapView: GMSMapView!
    
    @IBOutlet weak var lblAddress: CustomLabel!
    @IBOutlet weak var txtAddress: CustomLabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate Kuala Lumpur at zoom level 9.
        let camera = GMSCameraPosition.camera(withLatitude: 3.13832903, longitude: 101.68800037, zoom: 9)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: mapViewContainer.bounds.height), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.delegate = self
        
        self.mapViewContainer.insertSubview(mapView, at: 0)
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        initPlacesAutocomplete()
        
        DispatchQueue.main.async {
            self.mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.mapViewContainer.bounds.height)
        }
        
        if let location = currentLocation {
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel))
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    func initPlacesAutocomplete() {
        resultsViewController = GMSAutocompleteResultsViewController()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = Country.from(code: CarfixInfo().profile.countryCode)?.countryCode
        resultsViewController?.autocompleteFilter = filter
        
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        currentLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        txtAddress.text = place.formattedAddress
        
        self.mapView.animate(to: GMSCameraPosition.camera(withTarget: place.coordinate, zoom: zoomLevel))
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
        if let location = currentLocation {
            print("Location: \(location)")
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        currentLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        updateAddress()
    }
    
    func updateAddress() {
        CLGeocoder().reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, error) in
            
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    self.displayLocationInfo(placemark: pm)
                } else {
                    print("Problem with the data received from geocoder")
                }
            }
        })
    }
    
    var addressDict: [AnyHashable : Any]?
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        if let dict = placemark.addressDictionary {
            addressDict = dict
            if let addresses = dict["FormattedAddressLines"] {
                txtAddress.text = (addresses as! NSArray).componentsJoined(by: ", ")
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    @IBAction func confirmLocation(_ sender: Any) {
        if let item = self.delegate {
            if item.updateAddress.hasValue {
                item.updateAddress!(address: txtAddress.text, location: currentLocation)
            }
            if item.updateAddressExtra.hasValue {
                if let dict = addressDict {
                    item.updateAddressExtra!(address: txtAddress.text, location: currentLocation, name: dict["Name"] as? String, zip: dict["ZIP"] as? String, city: dict["City"] as? String, state: dict["State"] as? String, country: dict["Country"] as? String)
                }
            }
        }
        self.close(sender: self)
    }
}

@objc protocol NewClaimMapControllerDelegate {
    @objc optional func updateAddress(address: String?, location: CLLocation?) -> Void
    @objc optional func updateAddressExtra(address: String?, location: CLLocation?, name: String?, zip: String?, city: String?, state: String?, country: String?)
}
