//
//  Profile.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class Profile : JSONSerializable {
    
    var id : Int?
    var first_name : String?
    var last_name : String?
    var email : String?
    var mobile : String?
    var country_code: String?
    var avatar : String?
    var device_token : String?
    var access_token : String?
    var currency : String?
    var service : ServiceModel?
    var serviceID : Int?
    var wallet_balance : Float?
    var measurement : String?
    var profile : LocalizationEntity?
    var card : Int?
    var cash : Int?
    var stripe_secret_key : String?
    var stripe_publishable_key : String?
    var login_by : String?
    var referral_count : String?
    var referral_unique_id : String?
    var referral_total_text : String?
    var referral_text : String?
    var otp : Int?
    var ride_otp : Int?
    
    init() {   }
    
}


struct ServiceModel: JSONSerializable {
    var service : Int?
    var provider_id : Int?
    var service_type : ServiceTypeModel?
    var service_model : String?
    var service_number : String?
    
}

struct ServiceTypeModel : JSONSerializable {
    var name: String?
    var id : Int?
}

struct LocalizationEntity : JSONSerializable {
    var language : Language?
}





