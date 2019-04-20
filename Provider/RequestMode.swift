//
//  RequestMode.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class RequestModel: JSONSerializable {
    var id: Int?
    var booking_id : String?
    var payment_mode : String?

//    var user_id: Int?
//    var service_type_id: Int?
    var status: String?
    var is_scheduled : String?
    var schedule_at : String?
    var paid: Int?
    var s_address: String?
    var s_latitude: Double?
    var s_longitude: Double?
    var d_address: String?
    var otp: String?
    var d_latitude: Double?
    var d_longitude: Double?
//   // var schedule_at:Int?
//    var route_key: String?
     var user : UserDetails?
    var user_rated : Float?
    var payment: PaymentModel?
    
}

struct  PaymentModel: JSONSerializable {
    var id: Int?
    //var promocode_id: Int?
    var payment_id : String?
    var payment_mode: String?
    var fixed: Float?
    var distance: Float?
    var commision: Float?
    var discount: Float?
    var tax : Float?
    var wallet: Float?
    var surge: Float?
    var total : Float?
    var payable: Float?
    var provider_commission : Float?
    var provider_pay: Float?
    
}


struct UserDetails: JSONSerializable {
    //    var device_id : String?
    //    var device_token: String?
    //    var device_type: String?
    //    var email : String?
    var first_name: String?
    var id: Int?
    var last_name : String?
    var rating : String?
        var mobile: String?
        var picture: String?
    //    var stripe_cust_id: String?
    //    var wallet_balance: Int?
    //    var user_id: Int?
    //    var request_id: Int?
    //    var status : Int?
    
    
}
