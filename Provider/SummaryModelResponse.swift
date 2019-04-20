//
//  SummaryModelResponse.swift
//  User
//
//  Created by CSS on 01/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct SummaryModelResponse: JSONSerializable {
    var rides: Int?
    var revenue: Float?
    var cancel_rides: Int?
    var scheduled_rides : Int?
}
