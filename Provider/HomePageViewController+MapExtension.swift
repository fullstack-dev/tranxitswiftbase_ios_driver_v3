//
//  HomePageViewController+MapExxtention.swift
//  User
//
//  Created by CSS on 06/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps



extension HomepageViewController : GMSMapViewDelegate,CLLocationManagerDelegate{
    
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      
        self.showView()

        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       
        self.hideView()
    }

    func showView(){ //MARK:- show ViewOffline View
//        if self.viewGoogleRetraction != nil {
//             self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Bottom)
//        }
       
        self.rideAcceptViewNib?.viewVisualEffect.showAnimateView((self.rideAcceptViewNib?.viewVisualEffect)!, isShow: true, direction: .Top)
        self.arrviedView?.viewVisualEffectMain.showAnimateView((self.arrviedView?.viewVisualEffectMain)!, isShow: true, direction: .Top)
        self.floatyButton?.isHidden = false
        self.tollView?.isHidden  = false
    }
    
    func hideView(){ //MARK:- hide Viewoffline view
//        if self.viewGoogleRetraction != nil {
//             self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: false, direction: .Top)
//        }
       
        self.rideAcceptViewNib?.viewVisualEffect.showAnimateView((self.rideAcceptViewNib?.viewVisualEffect)!, isShow: false, direction: .Bottom)
        self.arrviedView?.viewVisualEffectMain.showAnimateView((self.arrviedView?.viewVisualEffectMain)!, isShow: false, direction: .Bottom)
        self.floatyButton?.isHidden = true
        self.tollView?.isHidden  = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        self.currentBearing?(newHeading.trueHeading)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.tollView?.removeFromSuperview()
        self.tollView = nil
    }
    
    
    func setMapStyle(){ //MARK:- set map style 
        do {
            // Set the map style by passing a valid JSON string.
            if let url = Bundle.main.url(forResource: "Map_style", withExtension: "json") {
                self.gMSmapView.mapStyle = try GMSMapStyle(contentsOfFileURL: url)
            }else {
                print("error")
            }
            
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    
    func setGustureForGoogleMapRetraction(){
//        let gusture = UITapGestureRecognizer(target: self, action: #selector(openGoogleMap))
//        
//        viewGoogleRetraction.addGestureRecognizer(gusture)
    }
    
    @IBAction func openGoogleMap(){

        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            print(self.pickupLocation as Any, "   ", self.dropLocation as Any)
            
            guard let _ = self.pickupLocation, let _ = self.dropLocation, let url = URL(string: "comgooglemaps://?saddr=\(self.slat ?? 0),\(self.sLong ?? 0)&daddr=\(dLat ?? 0),\(dLong ?? 0)&directionsmode=driving"), UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url, options: [:]) { (true) in
                print("google map open")
            }
        } else {
            print("Can't use comgooglemaps://")
        }
    }
}


public extension CLLocation {
    
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
        
        let lat1 = self.coordinate.latitude.degreesToRadians
        let lon1 = self.coordinate.longitude.degreesToRadians
        
        let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
        let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return CGFloat(radiansBearing)
    }
    
    func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
        return bearingToLocationRadian(destinationLocation).radiansToDegrees
    }
}



extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

extension Double {
    var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
    var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
}

