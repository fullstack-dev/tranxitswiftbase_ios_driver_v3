//
//  YourTripModelResponse.swift
//  User
//
//  Created by CSS on 28/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation


struct  YourTripModelResponse: JSONSerializable {
    
    var id : Int?
    var booking_id : String?
    var user_id : Int?
    var status : String?
    var payment_mode : String?
    var paid : Int?
    var distance : Float?
    var s_address : String?
    var s_latitude: Double?
    var s_longitude : Double?
    var d_address: String?
    var started_at : String?
    var assigned_at : String?
    var schedule_at : String?
    var finished_at: String?
    var static_map : String?
    var payment: YourTripPaymentModel?
    var user : Provider?
    var rating : Rating?
    var service_type : ServiceType?
    var is_dispute : Int?
    var dispute : Dispute?
    
}

struct Dispute: JSONSerializable {
    var comments : String?
    var dispute_name : String?
    var dispute_type : String?
    var id : Int?
    var is_admin : Int?
    var refund_amount : Int?
    var status : String?
    var user_id : Int?
    var provider_id : Int?
    
}

struct YourTripPaymentModel: JSONSerializable {
    var id: Int?
    var fixed: Float?
    var distance : Float?
    var total : Float?
    var payable : Float?
    var provider_commission : Float?
    var provider_pay: Float?
    var tips : Float?
    
}

struct ServiceType: JSONSerializable {
    var name: String?
    var image : String?
}



