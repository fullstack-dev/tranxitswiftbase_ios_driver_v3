//
//  ApiList.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//Http Method Types

enum HttpType : String{
    
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
    case DELETE = "DELETE"
    
}

// Status Code

enum StatusCode : Int {
    
    case notreachable = 0
    case success = 200
    case multipleResponse = 300
    case unAuthorized = 401
    case notFound = 404
    case ServerError = 500
    
}


enum Base : String{
  
    case signUp = "/api/provider/register"
    
    case login = "/api/provider/oauth/token"
    
    //case resepwd = "/api/provider/profile/password"
    
    case distanceMarix = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="
    
    case updateLocation = "api/provider/profile/location"
    
    case onlineStatus = "api/provider/profile/available"
    
    case tripStatus = "api/provider/trip"
    
    case acceptRequest = "api/provider/trip/"
    
    case reject = "/api/provider/trip/"
    
    case updateStatus = "/api/provider/trip"
    
    case UpcommingCancel = "api/provider/cancel"

    case yourtrip = "/api/provider/requests/history"
    
    case upComming = "/api/provider/requests/upcoming"
    
    case forgotPassword = "/api/provider/forgot/password"
    
    case changePassword = "/api/provider/profile/password"
    
    case resetPassword = "/api/provider/reset/password"
    
    case invoiceAPI = "//api/provider/trip/"
    
    case updateProfile = "api/provider/profile"
    
    case getProfile = "/api/provider/profile"
    
    case summary = "/api/provider/summary"
    
    case earnings = "/api/provider/target"
    
    case logout = "/api/provider/logout"
    
    case upcomingTripDetail = "/api/provider/requests/upcoming/details"
    
    case pastTripDetail = "/api/provider/requests/history/details"
    
    case faceBookLogin = "/api/provider/auth/facebook"
    
    case googleLogin = "/api/provider/auth/google"
    
    case chatPush = "/api/provider/chat"
    
    case getWalletHistory = "/api/provider/wallettransaction"
    
    case requestAmount = "/api/provider/requestamount"
    
    case pendingTransferList = "/api/provider/transferlist"
    
    case cancelTransferRequest = "/api/provider/requestcancel"
    
    case updateLanguage = "/api/provider/profile/language"
    
    case getDocuments = "/api/provider/profile/documents"
    
    case getCards = "/api/provider/providercard"
    
    case postCards = "//api/provider/providercard"
    
    case deleteCard = "/api/provider/card/destory"
    
    case uploadDocuments = "/api/provider/profile/documents/store"
    
    case providerVerify = "/api/provider/verify"
    
    case versionCheck = "/api/user/checkversion"
    
    case help = "/api/provider/help"
    
    case settings = "/api/provider/settings"
    
    case cancelReason = "/api/provider/reasons"
    
    case waitingTime = "/api/provider/waiting"
    
    case instantRide = "/api/provider/requests/instant/ride"
    
    case phoneNubVerify = "/api/provider/verify-credentials"
    
    case estimateFare = "/api/user/estimated/fare_without_auth"
    
    case notificationManager = "/api/provider/notifications/provider"
    
    case postDispute = "/api/provider/dispute"
    
    case getDisputeList = "/api/provider/dispute-list"
    
    case walletTransactionDetails = "/api/provider/wallettransaction/details"
    
    case addMoney = "/api/provider/add/money"

    init(fromRawValue: String){
        self = Base(rawValue: fromRawValue) ?? .signUp
    }
    
    static func valueFor(Key : String?)->Base{
        
        guard let key = Key else {
            return Base.signUp
        }
        
//        for val in iterateEnum(Base.self) where val.rawValue == key {
//            return val
//        }
        
        if let base = Base(rawValue: key) {
            return base
        }
        
        return Base.signUp
        
    }
    
}
