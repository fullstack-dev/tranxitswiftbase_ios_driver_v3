//
//  Earnings.swift
//  User
//
//  Created by CSS on 05/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct EarnigsModel:JSONSerializable {
    var rides_count : Int?
    var target : String?
    var rides : [ridesArray]?
}

struct ridesArray: JSONSerializable {
    var distance : Double?
    var finished_at : String?
    var payment : PaymentModel?
    
}


