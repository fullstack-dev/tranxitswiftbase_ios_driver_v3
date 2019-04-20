//
//  AcceptModel.swift
//  User
//
//  Created by CSS on 23/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation


struct AcceptModelReponse: JSONSerializable {
    //var error : String?
    var id : Int?
    var booking_id : String?
    var provider_id: Int?
    var status : String?
    var cancelled_by : String?
    var payment_mode: String?
    var paid: String?
    var s_address: String?
    var d_address: String?
    var s_latitude: Double?
    var s_longitude: Double?
    var d_latitude : Double?
    var d_longitude: Double?
    var otp: Int?
    var user: userInsideModel?
}

struct userInsideModel: JSONSerializable {
    var id: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var gender : String?
    var mobile: String?
    var country_code: String?
    var picture: String?
    var device_id: String?
    var device_token: String?
    var latitude: Double?
    var longitude: Double?
    
    
    
}

