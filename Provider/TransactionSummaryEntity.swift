//
//  TransactionSummaryEntity.swift
//  Provider
//
//  Created by Sravani on 22/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

struct TransactionDetailsEntity : JSONSerializable {
    
    var wallet_details : [Wallet_details]?
}

struct Wallet_details : JSONSerializable {
    var id : Int?
    var provider_id : Int?
    var transaction_id : Int?
    var transaction_alias : String?
    var transaction_desc : String?
    var type : String?
    var amount : Double?
    var open_balance : Double?
    var close_balance : Double?
    var payment_mode : String?
}
