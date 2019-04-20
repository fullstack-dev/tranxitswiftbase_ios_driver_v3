//
//  GoogleMapsHelper.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit

typealias LocationCoordinate = CLLocationCoordinate2D
typealias LocationDetail = (address : String, coordinate :LocationCoordinate)
typealias LocationDuration = (duration: String, distance: String)

private struct Place : Decodable {
    
    var results : [Address]?
    
}

private struct Address : Decodable {
    
    var formatted_address : String?
    var geometry : Geometry?
}

private struct Geometry : Decodable {
    
    var location : Location?
    
}

private struct Location : Decodable {
    
    var lat : Double?
    var lng : Double?
}


//MARK:- distance matrix

private struct Modal : Decodable {
    
    var rows : [Row]?
}

private struct Row : Decodable {
    var elements : [Element]?
    
}

private struct Element : Decodable {
    var duration : Duration?
}

private struct Duration : Decodable {
    var text : String?
}


class GoogleMapsHelper : NSObject {
    
    var mapView : GMSMapView?
    var locationManager : CLLocationManager?
    private var currentLocation : ((CLLocation)->Void)?
    var currentBearing : ((CLLocationDirection)->Void)?
    var backGroundInstanse = BackGroundTask.backGroundInstance
    
    func getMapView(withDelegate delegate: GMSMapViewDelegate? = nil, in view : UIView, withPosition position :LocationCoordinate = defaultMapLocation, zoom : Float = 12) {
       mapView = GMSMapView(frame: view.frame)
       mapView?.delegate = delegate
       mapView?.camera = GMSCameraPosition.camera(withTarget: position, zoom: 12)
       view.addSubview(mapView!)
    }
    
    func getCurrentLocation(onReceivingLocation : @escaping ((CLLocation)->Void)){
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager?.startUpdatingHeading()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        self.currentLocation = onReceivingLocation
    }
    
    func moveTo(location : LocationCoordinate = defaultMapLocation, with center : CGPoint) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            self.mapView?.camera = GMSCameraPosition.camera(withTarget: location, zoom: 15)
            self.mapView?.center = center
        }
        CATransaction.commit()
    }
    
    func getPlaceAddress(from location : LocationCoordinate, on completion : @escaping ((LocationDetail)->())){
        
        /*if !geoCoder.isGeocoding {
            
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { (placeMarks, error) in
                
                guard error == nil, let placeMarks = placeMarks else {
                    print("Error in retrieving geocoding \(error?.localizedDescription ?? .Empty)")
                    return
                }
            
                
                
                guard let placemark = placeMarks.first, let address = (placeMarks.first?.addressDictionary!["FormattedAddressLines"] as? Array<String>)?.joined(separator: ","), let coordinate = placemark.location else {
                    print("Error on parsing geocoding ")
                    return
                }
                
                
                completion((address,coordinate.coordinate))
                
                print(placeMarks)
                
            }
            
        } */
        
        
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(googleMapKey)"
        
        guard let url = URL(string: urlString) else {
            print("Error in creating URL Geocoding")
            return
        }
       
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let places = data?.getDecodedObject(from: Place.self),
                let address = places.results?.first?.formatted_address, let lattitude = places.results?.first?.geometry?.location?.lat, let longitude = places.results?.first?.geometry?.location?.lng {
                
                completion((address, LocationCoordinate(latitude: lattitude, longitude: longitude)))
            }
            
            
        }.resume()
        
    
        
    }
    
    
    
    func getTavelDuration(from location: String, on completion : @escaping ((LocationDuration)->())){
        
        let urltsring = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=13.0590,80.254&destinations=13.0732,80.2609&key=AIzaSyAlpDGEYqZS44sI_ffynh5sjm5JsNPPFLg"
        guard let url = URL(string: urltsring) else {
            print("Error in creating url")
            return
        }
        
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print(data as Any)
            
            if let places = data?.getDecodedObject(from: Modal.self) {
                
                print("duarion Value: \(String(describing: places.rows?.first?.elements?.first?.duration?.text))")
                completion(("\(places.rows?.first?.elements?.first?.duration?.text ?? "")", "ef"))
                
            }
        }
     
        .resume()
    
    
    }
    
    
}


extension GoogleMapsHelper: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
          print("Location: \(location)")
          self.currentLocation?(location)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        self.currentBearing?(newHeading.trueHeading)
        
    }
    
}
