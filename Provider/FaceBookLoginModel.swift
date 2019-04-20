//
//  FaceBookLoginModel.swift
//  User
//
//  Created by CSS on 29/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct FacebookLoginModel: JSONSerializable {
    
    var device_id : String?
    var device_token : String?
    var device_type : String?
    var accessToken : String?
    var login_by : String?
    var mobile: Int?
    var country_code: String?
    
}

struct FacebookLoginModelResponse: JSONSerializable {
    var name: String?
    var access_token : String?
}
