//
//  invoceModel.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct InvoiceModel: JSONSerializable {
    var rating: Int?
    var comment: String?
}

struct InvoiceModelResponse: JSONSerializable {
    var message: String?
    
}
