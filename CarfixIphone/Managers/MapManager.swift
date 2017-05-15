//
//  MapManager.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapManager {
    var mMap: GMSMapView
    init(_ mapView: GMSMapView) {
        mMap = mapView
    }
    
    func getDirections(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(end.latitude),\(end.longitude)&key=AIzaSyDxSgGQX6jrn4iq6dyIWAKEOTneZ3Z8PtU")
        let request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    //print(jsonResult)
                    
                    let routes = jsonResult.value(forKey: "routes")
                    
                    if let routes = routes as? NSArray {
                        if let route = routes[0] as? NSDictionary {
                            if let polyline = route["overview_polyline"] as? NSDictionary {
                                if let points = polyline["points"] as? String {
                                    if points != "" {
                                        DispatchQueue.main.async() {
                                            if let path = self.drawRoute(start: start, end: end, with: points) {
                                                var bounds = GMSCoordinateBounds(coordinate: start, coordinate: end)
                                                for index in 1...path.count() {
                                                    bounds = bounds.includingCoordinate(path.coordinate(at: index))
                                                }
                                                self.mMap.animate(with: GMSCameraUpdate.fit(bounds))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch{
                print("Somthing wrong")
            }
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
    
    func drawRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, with encodedString: String) -> GMSPath? {
        mMap.clear()
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 2
        polyLine.strokeColor = CarfixColor.primary.color
        polyLine.map = mMap
        
        let smarker = GMSMarker()
        smarker.position = start
        smarker.icon = #imageLiteral(resourceName: "ic_towing_services").maskWithColor(color: UIColor.red)
        smarker.map = mMap
        
        let dmarker = GMSMarker()
        dmarker.position = end
        dmarker.icon = #imageLiteral(resourceName: "ic_location")
        dmarker.map = mMap
        
        //rfeng: remove this later
//        stackMove(marker: smarker, from: nil, polyline: polyLine, duration: 1.0, count: 0)
        
        return path
    }
    
    func stackMove(marker: GMSMarker, from: CLLocationCoordinate2D?, polyline: GMSPolyline, duration: Double, count: UInt) {
        
        if count >= polyline.path!.count() {
            return
        }
        
        let newPoint = polyline.path!.coordinate(at: count)
        let start = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        let end = CLLocation(latitude: newPoint.latitude, longitude: newPoint.longitude)
        
        let degrees = from == nil ? 0 : getBearingBetweenTwoPoints(point1: start, point2: end) - 90
        updateMarker(marker: marker, coordinates: newPoint, degrees: degrees, duration: duration)
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when, execute: { data in
            self.stackMove(marker: marker, from: newPoint, polyline: polyline, duration: duration, count: count + 1)
        })
    }
    
    func updateMarker(marker: GMSMarker, coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double) {
        
        if degrees != 0 {
            // Keep Rotation Short
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            marker.rotation = degrees
            CATransaction.commit()
        }
        
        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        marker.position = coordinates
        
        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        self.mMap.animate(with: camera)
        
        CATransaction.commit()
    }
    
    func radians(from degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func degrees(from radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = radians(from: point1.coordinate.latitude)
        let lon1 = radians(from: point1.coordinate.longitude)
        
        let lat2 = radians(from: point2.coordinate.latitude)
        let lon2 = radians(from: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return degrees(from: radiansBearing)
    }
}
