//
//  Protocol.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//MARK:- Web Service Protocol

protocol PostWebServiceProtocol : class {
    
    var interactor : PostInteractorOutputProtocol? {get set}
    
    var completion : ((CustomError?, Data?)->())? {get set}
    
    func retrieve(api : Base, url : String?, data : Data?, imageData: [String : Data]?, paramters : [String : Any]?, type : HttpType, completion : ((CustomError?, Data?)->())?)
    
}




//MARK:- Interator Input

protocol PostInteractorInputProtocol : class {
    
    var webService : PostWebServiceProtocol? {get set}
    
    func send(api : Base, data : Data?, paramters : [String : Any]?, type : HttpType)
    
    func send(api : Base, imageData : [String : Data]?, parameters: [String : Any]?)
    
    func send(api : Base, url : String, data : Data?, type : HttpType)
    
}


//MARK:- Interator Output

protocol PostInteractorOutputProtocol : class {
    
    var presenter : PostPresenterOutputProtocol? {get set}
    
    func on(api : Base, response : Data)
    
    func on(api : Base, error : CustomError)
    
}


//MARK:- Presenter Input

protocol PostPresenterInputProtocol : class {
    
    var interactor : PostInteractorInputProtocol? {get set}
    
    var controller : PostViewProtocol? {get set}
    /**
     Send POST Request
     @param api Api type to be called
     @param data HTTP Body
     */
    func post(api : Base, data : Data?)
    /**
     Send GET Request
     @param api Api type to be called
     @param parameters paramters to be send in request
     */
    
    func get(api : Base, parameters: [String : Any]?)
    
    /**
     Send GET Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     */
    
    func get(api : Base, url : String)
    
    /**
     Send POST Request
     @param api Api type to be called
     @param imageData : Image to be sent in multipart
     @param parameters : params to be sent in multipart
     */
    func post(api : Base, imageData : [String : Data]?, parameters: [String : Any]?)
    
    /**
     Send put Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func put(api : Base, url : String, data : Data?)
    
    /**
     Send delete Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func delete(api : Base, url : String, data : Data?)
    
    /**
     Send patch Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func patch(api : Base, url : String, data : Data?)
    
    /**
     Send Post Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func post(api : Base, url : String, data : Data?)
    
    
}


//MARK:- Presenter Output

protocol PostPresenterOutputProtocol : class {
    
  
    
    func onError(api : Base, error : CustomError)
    
    func SendAuth(api: Base, data: Data)
    
    func sendlogin(api: Base, data: Data)
    
    func sendResetPassword(api: Base, data: Data)
    
    func sendLocationupadate(api: Base, data: Data)
    
    func sendOnlineStatus(api: Base, data: Data)
    
    func SendAcceptStatus(api: Base, data: Data)
    
    func SendUpdateStatus(api: Base, data: Data)
    
    func sendRejectAPI(api: Base, data: Data)
    
    func sendYourTripsAPI(api: Base, data: Data)
    
    func sendUserData(api : Base, data : Data)
    
    func sendInvoiceData(api: Base, data:  Data)
    
    func sendProfile(api : Base, data : Data)
    
    func sendSummary(api: Base, data: Data)
    
    func sendEaringsAPI(api: Base, data: Data)
    
    func sendSuccess(api : Base, data : Data)
    
    func sendFaceBookAPI(api: Base, data: Data)
    
    func sendUpcomingResponse(api: Base, data: Data)
   
    func sendWalletEntity(api: Base, data: Data)
    
    func sendDocumentsEntity(api: Base, data: Data)
    
    func sendCardEntityList(api : Base, data : Data)

    func sendHelpAPI(api : Base, data: Data)
    
    func sendSetting(api : Base, data: Data)
    
    func sendReason(api : Base, data: Data)
    
    func sendWaitingTime(api : Base, data: Data)
    
    func sendEstimateFare(api : Base, data : Data)
    
    func sendNotificationList(api : Base, data : Data)
    
    func sendDisputeList(api : Base, data: Data)
    
    func sendDispute(api : Base, data: Data)
    
    func sendWalletTransactionDetails(api : Base , data: Data)
    
}


//MARK: - View

protocol PostViewProtocol : class {
    
    var presenter : PostPresenterInputProtocol? {get set}
    
    
    func onError(api : Base, message : String, statusCode code : Int)
    
    func getAuth(api: Base, data: UserData?)
    
    func getLogin(api: Base, data: LoginModel?)
    
    func getResetpassword(api: Base, data: resetPasswordModel?)
    
    func getLoactionUpadate(api: Base, data: updateLocationModelResponse?)
    
    func getOnlineStatus(api: Base, data: OnlinestatusModelResponse?)
    
    func GetAcceptStatus(api: Base, data: [AcceptModelReponse]?)
    
    func getUpdateStatus(api: Base, data: UpdateTripStatusModelResponse?)
    
    func getRejectAPI(api: Base, data: [RejectModelResponse]? )
    
    func getYourTripAPI(api: Base, data: [YourTripModelResponse]?)
    
    func getUserData(api : Base, data : ForgotResponse?)
    
    func getInvoiceData(api: Base, data: InvoiceModelResponse?)
    
    func getProfile(api : Base, data : Profile?)
    
    func getSummary(api: Base, data: SummaryModelResponse?)
    
    func getEarningsAPI(api: Base, data: EarnigsModel?)
    
    func getSucessMessage(api: Base, data: String?)
    
    func getAddCardSuccess(api: Base, data: String?)
    
    func getFaceBookAPI(api: Base, data: FacebookLoginModelResponse?)
    
    func getUpcomingtripResponse(api: Base, data: YourTripModelResponse?)
    
    func getWalletEntity(api : Base, data : WalletEntity?)
    
    func getDocumentsEntity(api : Base, data : DocumentsEntity?)
    
    func getCardEnities(api : Base, data : [CardEntity])

    func getHelp(api : Base, data : HelpEntity)
    
    func getSettings(api : Base, data : SettingsEntity)
    
    func getReason(api : Base, data : [ReasonEntity])
    
    func getWaitingTime(api : Base, data : WaitingTime)
    
    func getEstimateFare(api : Base, data : EstimateFareModel?)
    
    func getNotificationsMangerList(api : Base, data : [NotificationManagerModel]?)
    
    func getDisputeList(api : Base, data : [DisputeList])
    
    func getDispute(api : Base, data : DisputeList)
    
    func getWalletTransactionDetails(api: Base, data : TransactionDetailsEntity?)
    
}

//MARK: - View

extension PostViewProtocol {
    
    var presenter: PostPresenterInputProtocol? {
        
        get {
            presenterObject?.controller = self
            self.presenter = presenterObject
            return presenterObject
        }
        set(newValue){
            
            presenterObject = newValue
        }
    }
    
    func getAuth(api: Base, data: UserData?){ return }
    
    func getLogin(api: Base, data: LoginModel?){ return }
    
    func getResetpassword(api: Base, data: resetPasswordModel?) { return }
    
    func getLoactionUpadate(api: Base, data: updateLocationModelResponse?){ return }
    
    func getOnlineStatus(api: Base, data: OnlinestatusModelResponse?) { return }
    
    func GetAcceptStatus(api: Base, data: [AcceptModelReponse]?) { return }
    
    func getUpdateStatus(api: Base, data: UpdateTripStatusModelResponse?) { return }
    
    func getRejectAPI(api: Base, data: [RejectModelResponse]? ) { return }
    
    func getYourTripAPI(api: Base, data: [YourTripModelResponse]?) { return }

    func getUserData(api : Base, data : ForgotResponse?) { return }
    
    func getInvoiceData(api: Base, data: InvoiceModelResponse?){ return }
    
    func getProfile(api : Base, data : Profile?) { return }
    
    func getSummary(api: Base, data: SummaryModelResponse?){ return }
    
    func getEarningsAPI(api: Base, data: EarnigsModel?){return}
    
    func getSucessMessage(api: Base, data: String?){return}
    
    func getAddCardSuccess(api: Base, data: String?){return}
    
    func getFaceBookAPI(api: Base, data: FacebookLoginModelResponse?){return}
    
    func getUpcomingtripResponse(api: Base, data: YourTripModelResponse?){return}
    
    func getWalletEntity(api : Base, data : WalletEntity?) { return }
    
    func getDocumentsEntity(api : Base, data : DocumentsEntity?) {return}
    
    func getCardEnities(api : Base, data : [CardEntity]) {return}

    func getHelp(api : Base, data : HelpEntity) {return}
    
    func getSettings(api : Base, data : SettingsEntity) {return}
    
    func getReason(api : Base, data : [ReasonEntity]) {return}
    
    func getWaitingTime(api : Base, data : WaitingTime) {return}
    
    func getEstimateFare(api : Base, data : EstimateFareModel?) { return }
    
    func getNotificationsMangerList(api : Base, data : [NotificationManagerModel]?){return}
    
    func getDisputeList(api : Base, data : [DisputeList]){return}
    
    func getDispute(api : Base, data : DisputeList){return}
    
    func getWalletTransactionDetails(api : Base, data : TransactionDetailsEntity?){return}
}



