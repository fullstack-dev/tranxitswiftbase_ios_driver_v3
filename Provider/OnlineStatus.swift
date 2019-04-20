//
//  OnlineStatus.swift
//  User
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct OnlinestatusModel: JSONSerializable {

    var service_status  : String?
    
}

struct OnlinestatusModelResponse: JSONSerializable {
    
    var id : Int?
    var first_name : String?
    var error : String?
    var service : ServiceResponse?
    
}

struct ServiceResponse: JSONSerializable {
    var status : ServiceStatus?
    
}
