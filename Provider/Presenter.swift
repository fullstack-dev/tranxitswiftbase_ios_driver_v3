//
//  Presenter.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

class Presenter  {
    
    static let shared = Presenter()
    
    var interactor: PostInteractorInputProtocol?
    var controller: PostViewProtocol?
}

//MARK:- PostPresenterInputProtocol

extension Presenter : PostPresenterInputProtocol {

    func put(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data, type: .PUT)
    }
    
    func delete(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data, type: .DELETE)
    }
    
    func patch(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data,type: .PATCH)
    }
    
    func post(api: Base, data: Data?) {
        interactor?.send(api: api, data: data, paramters: nil, type: .POST)
    }
    
    func get(api: Base, parameters: [String : Any]?) {
        interactor?.send(api: api, data: nil, paramters: parameters, type: .GET)
    }
    
    func get(api : Base, url : String){
        
        interactor?.send(api: api, url: url, data: nil, type: .GET)

    }
    
    func post(api: Base, imageData: [String : Data]?, parameters: [String : Any]?) {
        interactor?.send(api: api, imageData: imageData, parameters: parameters)
    }
   
    
    func post(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data,type: .POST)
    }
    
}


//MARK:- PostPresenterOutputProtocol

extension Presenter : PostPresenterOutputProtocol {
    
    
    func sendWaitingTime(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: WaitingTime.self)
        controller?.getWaitingTime(api: api, data: responseValue!)
    }
    
    func sendReason(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [ReasonEntity].self) ?? []
        controller?.getReason(api: api, data: responseValue)
    }
    
    func sendSetting(api: Base, data: Data) {
        let responseValue = data.getDecodedObject(from: SettingsEntity.self)
        controller?.getSettings(api: api, data: responseValue!)
    }
    
    func sendHelpAPI(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: HelpEntity.self)
        controller?.getHelp(api: api, data: responseValue!)
    }
    
    func sendCardEntityList(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [CardEntity].self) ?? []
        controller?.getCardEnities(api: api, data: responseValue)
    }
    
    func sendUpcomingResponse(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: YourTripModelResponse.self)
        controller?.getUpcomingtripResponse(api: api, data: responseValue!)
    }
    
    func sendFaceBookAPI(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: FacebookLoginModelResponse.self)
        controller?.getFaceBookAPI(api: api, data: responseValue)
    }
    
    func sendSuccess(api: Base, data: Data) {
        
        let messageObject = data.getDecodedObject(from: DefaultMessage.self)
        let responseMessage = messageObject?.message ?? messageObject?.success
        
        if api == .postCards {
            
            controller?.getAddCardSuccess(api: api, data:  responseMessage)
        }
        else {
            controller?.getSucessMessage(api: api, data:  responseMessage)
        }
    }
    
    func sendEaringsAPI(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: EarnigsModel.self)
        controller?.getEarningsAPI(api: api, data: responseValue!)
    }
    
    
    func sendProfile(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: Profile.self)
        controller?.getProfile(api: api, data: responseValue)
    }
    
    
    func sendInvoiceData(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: InvoiceModelResponse.self)
        controller?.getInvoiceData(api: api, data: responseValue)
    }
    
    
    func sendYourTripsAPI(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [YourTripModelResponse].self)
        controller?.getYourTripAPI(api: api, data: responseValue)
    }
    
    
    func sendRejectAPI(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [RejectModelResponse].self)
        controller?.getRejectAPI(api: api, data: responseValue)
    }
    
    
    func SendUpdateStatus(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: UpdateTripStatusModelResponse.self)
        controller?.getUpdateStatus(api: api, data: responseValue)
    }
    
    
    func SendAcceptStatus(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [AcceptModelReponse].self)
        controller?.GetAcceptStatus(api: .acceptRequest, data: responseValue)
    }
    
    
    func sendOnlineStatus(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: OnlinestatusModelResponse.self)
        controller?.getOnlineStatus(api: api, data: responseValue)
    }
    
    
    func sendLocationupadate(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: updateLocationModelResponse.self)
        controller?.getLoactionUpadate(api: api, data: responseValue)
    }
    
    
    func sendResetPassword(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: resetPasswordModel.self)
        controller?.getResetpassword(api: api, data: responseValue)
    }
    
    
    func sendlogin(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: LoginModel.self)
        controller?.getLogin(api: api, data: responseValue)
    }
    
    
    func SendAuth(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: UserData.self)
        controller?.getAuth(api: api, data: responseValue)
    }
    
    
    func onError(api: Base, error: CustomError) {
        
        controller?.onError(api: api, message: error.localizedDescription , statusCode: error.statusCode)
    }
    
    
    func sendUserData(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: ForgotResponse.self)
        controller?.getUserData(api: api, data: responseValue)
    }
    
    
    func sendSummary(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: SummaryModelResponse.self)
        controller?.getSummary(api: api, data: responseValue)
    }
    
    
    func sendWalletEntity(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: WalletEntity.self)
        controller?.getWalletEntity(api: api, data: responseValue)
    }
    
    
    func sendDocumentsEntity(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: DocumentsEntity.self)
        controller?.getDocumentsEntity(api: api, data: responseValue)
    }
    
    
    func sendEstimateFare(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: EstimateFareModel.self)
        controller?.getEstimateFare(api: api, data: responseValue)
    }
    
    
    func sendNotificationList(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [NotificationManagerModel].self)
        controller?.getNotificationsMangerList(api: api, data: responseValue)
    }
    
    
    func sendDispute(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: DisputeList.self)
        controller?.getDispute(api: api, data: responseValue!)
    }
    
    
    func sendDisputeList(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: [DisputeList].self) ?? []
        controller?.getDisputeList(api: api, data: responseValue)
    }
    
    
    func sendWalletTransactionDetails(api: Base, data: Data) {
        
        let responseValue = data.getDecodedObject(from: TransactionDetailsEntity.self)
        controller?.getWalletTransactionDetails(api: api, data: responseValue)
    }
    
    func getRequestDetails(data: Data)-> GetRequestModelResponse? {
        
        return data.getDecodedObject(from: GetRequestModelResponse.self)
    }
    
    // MARK:- Get Card
    
    func getCards(data : Data)->[CardEntity] {
        return data.getDecodedObject(from: [CardEntity].self) ?? []
    }
}


