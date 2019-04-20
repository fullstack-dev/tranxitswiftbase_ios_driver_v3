//
//  UpdateTripStatusModel.swift
//  User
//
//  Created by CSS on 23/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct UpdateTripStatusModel: JSONSerializable {
    
    var latitude : Double?
    var longitude : Double?
    var toll_price : Double?
    var status : String?
    var _method : String?
    
}

struct UpdateTripStatusModelResponse: JSONSerializable {
    var error: String?
    var id : Int?
    var booking_id : String?
    var user_id : Int?
    var status : String?
    var payment_mode : String?
    var paid : Int?
    var distance : Int?
    var s_address : String?
    var s_latitude: Double?
    var s_longitude : Double?
    var d_address: String?
    var started_at : String?
    var finished_at: String?
    var static_map : String?
    var user : userUpdateDeatil?
}

struct userUpdateDeatil: JSONSerializable {
    var first_name: String?
    var id: Int?
    var last_name : String?
    var rating : String?
}
