//
//  loginModel.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation


struct LoginModel: JSONSerializable {

    var email :  String?
    var password: String?
    var device_id : String?
    var device_token : String?
    var device_type : String?
    var access_token : String?
    
}
