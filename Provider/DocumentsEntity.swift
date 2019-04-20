//
//  DocumentsEntity.swift
//  Provider
//
//  Created by CSS on 24/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct DocumentsEntity : JSONSerializable {
    var documents : [DocumentsModel]?
}

struct DocumentsModel : JSONSerializable {
    var id : Int?
    var name : String?
    var type : String?
    var providerdocuments : DocumentsMetadata?
}

struct DocumentsMetadata : JSONSerializable {
    var url : String?
    var status : DocumentStatus?
    
}

enum DocumentStatus : String, Codable {
    case processing = "ASSESSING"
    case approved = "ACTIVE"
}
