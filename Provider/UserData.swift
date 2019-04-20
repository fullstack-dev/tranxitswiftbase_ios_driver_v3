//
//  UserData.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct UserData : JSONSerializable {

    static var main = UserData()
    var first_name : String?
    var last_name : String?
    var email : String?
    var mobile : String?
    var password : String?
    var password_confirmation : String?
    var device_id : String?
    var device_type : String?
    var device_token : String?
    var access_token : String?
    var referral_code:String?
    var service_type:String?
    var service_number : String?
    var service_model:String?
    var country_code:String?
    
    
}

class UserDataResponse : JSONSerializable {
    
    var id : Int?
    var email : String?
    var device_type : DeviceType?
    var device_token : String?
    var login_by : LoginType?
    var password : String?
    var password_old : String?
    var password_confirmation : String?
    var social_unique_id : String?
    var device_id : String?
    var otp : Int?
    
}

class ForgotResponse : JSONSerializable {
    
    var provider : UserDataResponse?
    var message: String?
}
