//
//  InstantRideModel.swift
//  Provider
//
//  Created by Sravani on 10/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

struct instantRideModel: JSONSerializable {
    
    var mobile: String?
    var s_latitude:  Double?
    var s_longitude: Double?
    var d_latitude:  Double?
    var d_longitude: Double?
    var s_address: String?
    var d_address:String?
    var country_code: String?
}



