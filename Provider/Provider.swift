//
//  Provider.swift
//  User
//
//  Created by CSS on 15/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct Provider : JSONSerializable {
    
    var id : Int?
    var latitude :Double?
    var longitude :Double?
    var avatar : String?
    var picture: String?
    var first_name : String?
    var last_name : String?
    var rating : String?
    var mobile : String?
    
}
