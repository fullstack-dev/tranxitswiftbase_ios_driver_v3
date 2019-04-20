//
//  updateLocationModal.swift
//  User
//
//  Created by CSS on 18/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct updateLocationModel : JSONSerializable{

    
    var latitude: Double?
    var longitude : Double?
    
}

struct  updateLocationModelResponse: JSONSerializable {    
    var message : String?
}
