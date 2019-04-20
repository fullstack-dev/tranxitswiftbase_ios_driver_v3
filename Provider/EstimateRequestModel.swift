//
//  EstimateRequestModel.swift
//  Provider
//
//  Created by Sravani on 10/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

struct EstimateRequestModel: JSONSerializable {
    
    
    var s_latitude:  Double?
    var s_longitude: Double?
    var d_latitude:  Double?
    var d_longitude: Double?
    var service_type : Int?
}
