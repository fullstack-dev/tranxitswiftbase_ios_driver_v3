//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "Tranxit Driver"
var deviceTokenString = Constants.string.noDevice
var deviceId = Constants.string.noDevice

let googleMapKey = "AIzaSyCKTSqyNLap7VgehJft0j9amCn52i0u7tQ"
let appSecretKey = "CFsmzTFpcFK1pNRTPMQ7YD5nUMPe53rTRM9i2O4b"
let appClientId = 2

var helpMail = "support@tranxit.com"
var helpEmailContant = "Hello \(AppName)"
let helpWeblink = baseUrl
var helpPhoneNumber = "1098"
let defaultMapLocation = LocationCoordinate(latitude: 13.009245, longitude: 80.212929)
let baseUrl = "http://schedule.deliveryventure.com/"
let stripePublishableKey = "pk_test_DbfzA8Pv1MDErUiHakK9XfLe"

let driverBundleID = "com.appoets.tranxit.user"

enum AppStoreUrl : String {
    
    case user = "https://itunes.apple.com/us/app/tranxit/id1204487551?ls=1&mt=8"
    case driver = "https://itunes.apple.com/us/app/tranxit-driver/id1204269279?mt=8"
}
