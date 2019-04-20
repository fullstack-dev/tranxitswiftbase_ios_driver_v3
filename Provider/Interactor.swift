//
//  Interactor.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

class Interactor  {
    
    var webService: PostWebServiceProtocol?
    
    var presenter: PostPresenterOutputProtocol?
    
}

//MARK:- PostInteractorInputProtocol

extension Interactor : PostInteractorInputProtocol {
    
    func send(api: Base, url: String, data: Data?, type: HttpType) {
        
        webService?.retrieve(api: api,url: url, data: data, imageData: nil, paramters: nil, type: type, completion: nil)
    }
    
    func send(api: Base, data: Data?, paramters: [String : Any]?, type: HttpType) {
        
        webService?.retrieve(api: api,url: nil, data: data, imageData: nil, paramters: paramters, type: type, completion: nil)
    }
    
    func send(api: Base, imageData: [String : Data]?, parameters: [String : Any]?) {
        
        webService?.retrieve(api: api,url: nil, data: nil, imageData: imageData, paramters: parameters, type: .POST, completion: nil)
    }
}

//MARK:- PostInteractorOutputProtocol

extension Interactor : PostInteractorOutputProtocol {
    
    func on(api: Base, response: Data) {
        
        switch api {
            
        case .signUp:
            self.presenter?.SendAuth(api: api, data: response)
        case .login:
            self.presenter?.sendlogin(api: api, data: response)
        case .updateLocation:
            self.presenter?.sendLocationupadate(api: api, data: response)
        case .onlineStatus:
            self.presenter?.sendOnlineStatus(api: api, data: response)
        case .acceptRequest:
            self.presenter?.SendAcceptStatus(api: api, data: response)
        case .updateStatus, .UpcommingCancel:
            self.presenter?.SendUpdateStatus(api: api, data: response)
        case .reject:
            self.presenter?.sendSuccess(api: api, data: response)
        case .yourtrip, .upComming:
            self.presenter?.sendYourTripsAPI(api: api, data: response)
        case .forgotPassword:
            self.presenter?.sendUserData(api: api, data: response)
        case .invoiceAPI:
            self.presenter?.sendInvoiceData(api: api, data: response)
        case .updateProfile, .getProfile:
            self.presenter?.sendProfile(api: api, data: response)
        case .summary:
            self.presenter?.sendSummary(api: api, data: response)
        case .earnings:
            self.presenter?.sendEaringsAPI(api: api, data: response)
        case .logout:
            self.presenter?.sendSuccess(api: api, data: response)
        case .changePassword, .resetPassword, .requestAmount, .cancelTransferRequest, .postCards, .deleteCard, .phoneNubVerify, .instantRide:
            self.presenter?.sendSuccess(api: api, data: response)
        case .pastTripDetail, .upcomingTripDetail:
            self.presenter?.sendUpcomingResponse(api: api, data: response)
        case .faceBookLogin, .googleLogin:
            self.presenter?.sendFaceBookAPI(api: api, data: response)
        case .getWalletHistory, .pendingTransferList, .addMoney:
            self.presenter?.sendWalletEntity(api: api, data: response)
        case .getDocuments, .uploadDocuments:
            self.presenter?.sendDocumentsEntity(api: api, data: response)
        case .getCards:
            self.presenter?.sendCardEntityList(api: api, data: response)
        case .help :
            self.presenter?.sendHelpAPI(api: api, data: response)
        case .settings :
            self.presenter?.sendSetting(api: api, data: response)
        case .cancelReason:
            self.presenter?.sendReason(api: api, data: response)
        case .waitingTime:
            self.presenter?.sendWaitingTime(api: api, data: response)
        case .estimateFare:
            self.presenter?.sendEstimateFare(api: api, data: response)
        case .notificationManager:
            self.presenter?.sendNotificationList(api: api, data: response)
        case .getDisputeList:
            self.presenter?.sendDisputeList(api: api, data: response)
        case .postDispute:
            self.presenter?.sendDispute(api: api, data: response)
            
        case .walletTransactionDetails:
            self.presenter?.sendWalletTransactionDetails(api: api, data: response)
            
        default :
            break
            
        }
    }
    
    func on(api: Base, error: CustomError) {
        
        presenter?.onError(api: api, error: error)
        
    }
    
    
}

