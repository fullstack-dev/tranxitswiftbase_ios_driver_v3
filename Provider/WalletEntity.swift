//
//  WalletEntity.swift
//  Provider
//
//  Created by CSS on 20/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct WalletEntity : JSONSerializable {
    var message : String?
    var wallet_balance : Float?
    var amount : Float?
    var type : UserType?
    var pendinglist : [WalletTransaction]?
    var wallet_transation : [WalletTransaction]?
   
}

struct WalletTransaction : JSONSerializable {
    var transaction_alias : String?
    var transaction_desc : String?
    var type : TransactionType?
    var amount : Float?
    var created_at : String?
    var alias_id : String?
    var id : Int?
    var transactions : [Transactions]?
}

struct Transactions : JSONSerializable {
    
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
    var created_at : String?
    
}

//struct DebitCardEntity : JSONSerializable {
//
//    var id: Int?
//    var last_four: String?
//    var card_id: String?
//    var is_default: Int?
//    var stripe_token: String?
//    var _method: String?
//    var strCardID: String?
//    var amount : String?
//    var type: String?
//    var payment_mode: String?
//}

struct CardEntity : JSONSerializable {
    var id : Int?
    var last_four : String?
    var card_id : String?
    var is_default : Int?
    var stripe_token : String?
    var _method : String?
    var strCardID : String?
    var amount : String?
}

struct AddMoneyEntity : JSONSerializable {
    var amount : String?
    var user_type : String?
    var payment_mode : String?
    var card_id : String?
}



