//
//  getRequestModel.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct GetRequestModelResponse: JSONSerializable {
    
    var account_status : AccountStatus?
    var service_status : ServiceStatus?
    var requests : [RequestInsideModel]?

}

struct RequestInsideModel: JSONSerializable {
    
    var id: Int?
    var request_id: Int?
    var provider_id: Int?
    var status: Int?
    var time_left_to_respond: Int?
    var request : RequestModel?
   
}




