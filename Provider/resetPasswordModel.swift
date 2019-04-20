//
//  resetPasswordModel.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation


struct resetPasswordModel:  JSONSerializable {
    
    
    var password: String?
    var password_confirmation : String?
    var password_old : String?
    
    
}
