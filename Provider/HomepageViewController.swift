////
//  HomepageViewController.swift
//  User
//
//  Created by CSS on 03/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import KWDrawerController
import IQKeyboardManagerSwift
import Floaty
import Crashlytics

class HomepageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var backSimmerBtnView: UIView!
    @IBOutlet var AcceptView: UIVisualEffectView!
    @IBOutlet var gMSmapView: GMSMapView!
    
    @IBOutlet var offlineView: UIView!
    @IBOutlet var viewCurrentLocation: UIView!
    @IBOutlet var viewGoogleRetraction: UIView!
    @IBOutlet var Menuimage: UIImageView!
    @IBOutlet var offlineImage: UIImageView!
    
    //MARK:- View outlets:
    @IBOutlet var menuBackView: UIView!
    
    
    //MARK:- button outlets:
    @IBOutlet var Simmer: ShimmerButton!
    
    @IBOutlet var viewGoogleNav: UIView!
    @IBOutlet var buttonGoogleMapRetraction: UIButton!
    //MARK:- lable outlets:
    @IBOutlet var labelPickupValue: UILabel!
    @IBOutlet var labelPickUp: UILabel!
    
    var rideAcceptViewNib : RideAcceptView?
    var estimatedAlert : InstantRideConfirmView?
    
    
   
    var userOfflineView : offlineView?
    var inVoiceView : invoiceView?
    var OTPScreen : OTPScreenView?
    var ratingViewNib : RatingView?
    var requestDetail: GetRequestModelResponse?
    
    var sourceMarker : GMSMarker = {
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.icon =  #imageLiteral(resourceName: "destination").resizeImage(newWidth: 30)
        return marker
    }()
    
    var arrviedView : rideArrivedView? {
        didSet {
            if self.arrviedView == nil {
                self.floatyButton?.removeFromSuperview()
            }
        }
    }
    private var destinationMarker : GMSMarker = {
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.icon =  #imageLiteral(resourceName: "Source").resizeImage(newWidth: 30)
        return marker
    }()
    
    var tollView : TollFeeView?
    var moveMarker = GMSMarker()
    private var isScheduled = false // Flag for Scheduled Ride
    var userPhoneNumber = Int()
    var userProfile = String()
    var mapViewHelper : GoogleMapsHelper?
    internal var timer : Timer?
    var locationManager:CLLocationManager!
    
    var reasonView : ReasonView?
    
    var instantRideView : LocationSelectionView?
    var isInstantRide = false // Flag for Instant Ride
    
    var cancelReason = [ReasonEntity]()
    var floatyButton : Floaty?
    
    var seconds = 0
    var waitingTimer : Timer?
    
    var isTimerRunning = false
    var waitingFirstCall = true
    
    var isRerouteEnable:Bool = false
    var pathIndex = 0
    var destinationLocation:CLLocationCoordinate2D?
    
    
    var documentController: UINavigationController? // Document View Controller
    var addCardVC: UINavigationController?
    
    private var location : Bind<CLLocationCoordinate2D> = Bind<CLLocationCoordinate2D>(nil)
    var currentBearing : ((CLLocationDirection)->Void)?
    var backGroundInstanse = BackGroundTask.backGroundInstance
    var storeReview = StoreReview()
    var userOtp : String?
    
    var requestID : Int = 0
    
    var timeSecond = 60
    var yourLocation : CLLocation? = nil
    var latestLocation : CLLocation? = nil
    var pickupLocation : String?
    var dropLocation : String?
    var slat : Double?
    var sLong : Double?
    var dLat : Double?
    var dLong: Double?
    
    private var onlineStatus : ServiceStatus = .NONE {
        didSet {
            self.Simmer.setTitle({
                if self.requestDetail?.account_status == .approved && (self.view.tag == 1){ // If not initially loaded
                    if onlineStatus == .OFFLINE {
                        self.loadOfflineNib()
                    } else {
                        self.removeOfflineView()
                    }
                    return onlineStatus.stringValue.localize()
                }else if self.requestDetail?.account_status == .balance {
                    self.loadOfflineNib()
                    return onlineStatus.stringValue.localize()
                } else {
                    return Constants.string.logout.localize()
                }
            }(), for: .normal)
        }
    }

    private var accountStatus: AccountStatus = .none {
        didSet {
            DispatchQueue.main.async { // If Showing document page and
//                if self.accountStatus == .pendingCard{
//                    self.getPendingDocuments(from: Storyboard.Ids.AddCardViewController)
//                }else if self.accountStatus == .pendingDocument {
//                    self.getPendingDocuments(from: Storyboard.Ids.DocumentsTableViewController)
//                } else {
//                    self.removeDocumentsVC()
//                    self.removeCardVC()
//                }
                if self.accountStatus == .approved {
                    self.userOfflineView?.viewAutoScrollNotVerified.isHidden = true
                }else if self.accountStatus == .balance {
                    self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                    self.userOfflineView?.scrollTextVerified = false
                }else {
                    self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                    self.userOfflineView?.scrollTextVerified = true
                }
            }
        }
    }
    
    var yourLocationBearing : CGFloat {
        guard self.yourLocation != nil, self.latestLocation != nil else {
            return .leastNonzeroMagnitude
        }
        return latestLocation!.bearingToLocationRadian(self.yourLocation!)
        
    }
    
    
    
    lazy var loader : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow!)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loader.isHidden = false
        self.setGooglemap()
        self.initialLoad()
    }
    
    // if driver app exist need to show warning alert
    func checkUserAppExist() {
        let app = UIApplication.shared
        let bundleId = driverBundleID+"://"
        
        if app.canOpenURL(URL(string: bundleId)!) {
//            let appExistAlert = UIAlertController(title: "", message: , preferredStyle: .alert)
//
//            appExistAlert.addAction(UIAlertAction(title: Constants.string.Continue.localize(), style: .default, handler: { (Void) in
//                print("App is install")
//            }))
//            present(appExistAlert, animated: true, completion: nil)
            self.view.make(toast: Constants.string.warningMsg.localize())
        }
        else {
            print("App is not installed")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //IQKeyboardManager.sharedManager().enable = false
        
        self.navigationController?.isNavigationBarHidden = true
        userOfflineView?.setAutoScroll()
        self.Simmer.setTitle(onlineStatus.stringValue.localize(), for: .normal)
        self.presenter?.get(api: .getProfile, parameters: nil) // Getting Profile Details
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.presenter?.get(api: .cancelReason, parameters: nil)
        })
        waitingTimer?.invalidate()
        waitingTimer = nil
        self.arrviedView?.hideWaitingTime = true
        
        // Chat push redirection
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: NSNotification.Name("ChatPushRedirection"), object: nil)
        
    }
    
    @objc func isChatPushRedirection() {
       
        if let ChatPage = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SingleChatController) as? SingleChatController {
            ChatPage.set(user: self.requestDetail!, requestId: self.requestID)
            let navigation = UINavigationController(rootViewController: ChatPage)
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //IQKeyboardManager.sharedManager().enable = true
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFont(TextField: nil, label: nil, Button: self.Simmer, size: 18, with: true)
        self.viewGoogleNav.makeRoundedCorner()
    }
    
    deinit {
        AVPlayerHelper.player.stop()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    lazy var markerProviderLocation : GMSMarker = {  // Provider Location Marker
        
        let marker = GMSMarker()
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        imageView.contentMode =  .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "mapvehicle")
        marker.iconView = imageView
        marker.map = self.gMSmapView
        return marker
        
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        print("Called ",#function)
    }
}

extension HomepageViewController {
    
    private func initialLoad(){
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.viewGoogleRetraction.isHidden = true
        
        self.mapViewHelper = GoogleMapsHelper()

        self.setCommonFont()
        self.getRequestValue()
        self.setSubView()
        self.addTapGusture()
        self.addBlurView()
        self.simmerBtnAction()
        self.getUserCurrentLocation()
        self.setMapStyle()
        self.setActionForGoogleMapRetraction()
        
        self.removeDocumentsVC()
        self.removeCardVC()
        self.instantRideSattus()
        
    }
    
    //Instant Ride
    func instantRideSattus() {
        if isInstantRide {
            self.loader.isHidden = true
            if self.instantRideView == nil, let instantRideView = Bundle.main.loadNibNamed(XIB.Names.LocationSelectionView, owner: self, options: [:])?.first as? LocationSelectionView {
                instantRideView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: instantRideView.frame.height)
                self.instantRideView = instantRideView
                self.view.addSubview(instantRideView)
                
                self.instantRideView?.onClickInstantRideBackBtn = { _ in
                    self.isInstantRide = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.getRequestValue()
                    })
                }
            }
        }
        else {
            checkUserAppExist()
        }
    }
    
    func removeDocumentsVC() {
        self.documentController?.dismiss(animated: true, completion: {
            self.documentController = nil
        })
    }
    
    func removeCardVC() {
        self.addCardVC?.dismiss(animated: true, completion: {
            self.addCardVC = nil
        })
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: labelPickupValue, Button: nil, size: 14)
        setFont(TextField: nil, label: labelPickUp, Button: nil, size: 14)
    }
    
    func setActionForGoogleMapRetraction(){
        self.buttonGoogleMapRetraction.addTarget(self, action: #selector(setGoogleMapAction(button:)), for: .touchUpInside)
    }
    
    @objc func setGoogleMapAction(button: UIButton){
        openGoogleMap()
    }
    
    func drawPoly(s_latitude: Double?, s_longtitude : Double?, d_latitude: Double?, d_longtitude: Double?){
        let polyLineSource = CLLocationCoordinate2D(latitude: s_latitude! , longitude: s_longtitude!)
        let polyLineDestination = CLLocationCoordinate2D(latitude: d_latitude!, longitude: d_longtitude!)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.gMSmapView.drawPolygon(from: polyLineSource , to: polyLineDestination)
        }
    }
    
    @objc func getUserCurrentLocation() { //provider current location
        
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
            self.location.value = location.coordinate
            print("location Called")
            self.getCurrentLocation()
            if self.markerProviderLocation.map == nil {
                self.markerProviderLocation.map = self.gMSmapView
            }
            UIView.animate(withDuration: 0.5) {
                self.markerProviderLocation.position = location.coordinate
            }
            self.latestLocation = location
            self.updateTravelledPath(currentLoc: location.coordinate)
            self.checkPolyline(coordinate: location.coordinate)
            if self.isRerouteEnable {
                guard self.requestDetail?.requests?.count ?? 0 > 0 else {
                    return
                }
                if self.requestDetail?.requests![0].request?.status == requestType.pickedUp.rawValue {
                    self.drawPoly(s_latitude: self.latestLocation?.coordinate.latitude, s_longtitude: self.latestLocation?.coordinate.longitude, d_latitude: self.destinationLocation?.latitude, d_longtitude: self.destinationLocation?.longitude)
                }
            }
        })
        self.mapViewHelper?.currentBearing = { bearing in
            
            func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
                let heading: CGFloat = {
                    let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
                    switch UIDevice.current.orientation {
                    case .faceDown: return -originalHeading
                    default: return originalHeading
                    }
                }()
                
                return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
            }
            
            UIView.animate(withDuration: 1) {
                firebaseBearing = bearing
                self.markerProviderLocation.rotation = bearing//CLLocationDegrees(angle)
            }
        }
    }
    
    //OrientationAdjustment
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
    
    private func getRequestValue(){
        
        self.backGroundInstanse.backGround(with: self.location, completion: { (getRequestModel) in
            //  print("BackGround Value: \(getRequestModel.account_status?.rawValue)")
            if self.view.tag == 0 { //
                self.loader.isHideInMainThread(true)
                self.view.tag = 1
            }
            self.requestDetail = getRequestModel
            self.onlineStatus = self.requestDetail?.service_status ?? .NONE
//            self.accountStatus = ((self.requestDetail?.account_status) ?? .none)
            if self.requestDetail?.account_status == AccountStatus.approved {
                self.onlineStatus = self.requestDetail?.service_status ?? .NONE
                
                if self.view.tag == 0 {
                    self.GetOnlineStatus(status: ServiceStatus.ONLINE.rawValue)
                    self.view.tag = 1
                }
                
                self.removeDocumentsVC()
                self.removeCardVC()
                
                if (self.requestDetail?.requests?.count)! > 0 {
                    // self.checkServiceStatus()
                    let requestModel = self.requestDetail?.requests![0]
                    self.requestID = requestModel?.request?.id ?? 0
                    let requestStatus = requestModel?.request?.status
                    let bookingId = requestModel?.request?.booking_id
                    let totalAmount = requestModel?.request?.payment?.total
                    let payable = requestModel?.request?.payment?.payable
                    let paymentMode = requestModel?.request?.payment_mode?.lowercased().localize().uppercased()
                    let sourceLatitute   =  (requestModel?.request?.s_latitude)!
                    let sourceLongtitude = (requestModel?.request?.s_longitude)!
                    
                    var destinationLatitde:Double = 0
                    var destinationLontitude:Double = 0
                    if requestModel?.request?.d_latitude != nil && requestModel?.request?.d_longitude != nil {
                        destinationLatitde = (requestModel?.request?.d_latitude)!
                        destinationLontitude = (requestModel?.request?.d_longitude)!
                        self.destinationLocation = CLLocationCoordinate2D(latitude: (requestModel?.request?.d_latitude)!, longitude: (requestModel?.request?.d_longitude)!)
                    }
                    //user_rated
                    let userRating : Float = Float((requestModel?.request?.user?.rating ?? "0")) ?? 0
                    //let paidStatus = requestModel?.request?.paid
                    //                    let userRating : Float = Float((requestModel?.request?.user_rated ?? 0.0))
                    self.userProfile = requestModel?.request?.user?.picture ?? ""
                    self.userPhoneNumber = Int((requestModel?.request?.user?.mobile)!)!
                    self.userOtp = requestModel?.request?.otp
                    self.pickupLocation = requestModel?.request?.s_address
                    self.dropLocation = requestModel?.request?.d_address
                    self.slat = requestModel?.request?.s_latitude
                    self.sLong = requestModel?.request?.s_longitude
                    
                    self.dLat = requestModel?.request?.d_latitude
                    self.dLong = requestModel?.request?.d_longitude
                    self.isScheduled = requestModel?.request?.is_scheduled == "YES"
                    
                    if self.waitingFirstCall {
                        self.tapWaitingTime()
                    }
                    switch requestStatus {
                        
                    case requestType.searching.rawValue:
                        self.setSubView()
                        if destinationLatitde != 0 && destinationLontitude != 0 {
                            self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        }
                        
                        self.loadAcceptNib()
                        if self.isScheduled, let dateObject = Formatter.shared.getDate(from: requestModel?.request?.schedule_at, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss) {  // Set Date For  Scheduled Request
                            self.rideAcceptViewNib?.setSchedule(date: dateObject)
                        }
                        self.startTimer()
                        self.removeCancelView()
                        self.arrviedView?.hideWaitingTime = true
                        break
                    case requestType.started.rawValue:
                        AVPlayerHelper.player.stop()
                        //MARK:- set Marker for dource and destination
                        
                        if destinationLatitde != 0 && destinationLontitude != 0 {
                            self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        }
                        //self.setValueForGoogleRetractionView(address: requestModel?.request?.s_address ?? "", tripState: .started)
                        
                        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
                        self.pickupLocation = requestModel?.request?.s_address
                        self.dropLocation = requestModel?.request?.d_address
                        
                        self.userOtp = requestModel?.request?.otp
                        
                        //MARK:- draw ploy line
                        if BackGroundTask.backGroundInstance.userStoredDetail.latitude != nil { // Polyline to driver current location to pickup location
                            self.drawPoly(s_latitude: BackGroundTask.backGroundInstance.userStoredDetail.latitude, s_longtitude: BackGroundTask.backGroundInstance.userStoredDetail.lontitude, d_latitude: sourceLatitute, d_longtitude: sourceLongtitude)
                        }
                        
                        //                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        
                        self.getUserCurrentLocation()//MARK:- Here Update the current location and set "markerProviderLocation" marker.Once it will set it will update the current location.
                        
                        self.loadAndShowArrivedNib() //MARK:- here Arrived view XIB file loaded
                        
                        self.setValueForGoogleRetractionView(status: requestType.started.rawValue)
                        self.arrviedView?.hideWaitingTime = true
                        
                    case requestType.arrived.rawValue:
                        
                        // self.setValueForGoogleRetractionView(address: requestModel?.request?.d_address ?? "", tripState: .arrived)
                        
                        
                        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
                        self.loader.isHidden = true
                        self.gMSmapView.clear()
                        print("map Clear")
                        
                        if self.location.value?.latitude != nil {
                            //let driverLocation = CLLocationCoordinate2D(latitude: (self.location.value?.latitude)!, longitude: (self.location.value?.longitude)!)
                            
                            
                        }
                        
                        self.loadAndShowArrivedNib() //MARK:- here Arrived view XIB file loaded
                        self.setTitleForButton(status: requestType.arrived.rawValue) //MARK:- here update the status
                        
                        self.getUserCurrentLocation()//MARK:- Here Update the current location and set "markerProviderLocation" marker.Once it will set it will update the current location.
                        
                        self.setValueForGoogleRetractionView(status: requestType.arrived.rawValue)
                        self.arrviedView?.hideWaitingTime = true
                        //MARK:- set Marker for dource and destination
                        self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        
                    case requestType.pickedUp.rawValue:
                        
                        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
                        self.loader.isHidden = true
                        self.gMSmapView.clear()
                        
                        //MARK:- set Marker for dource and destination
//                        if destinationLatitde != 0 && destinationLontitude != 0 {
                            self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                            
                            self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                            
//                        }
                        
                        self.loadAndShowArrivedNib()
                        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomepageViewController.startPickupToDropProgess), userInfo: nil, repeats: true)
                        self.setTitleForButton(status: requestType.pickedUp.rawValue)
                        self.getUserCurrentLocation()//MARK:- Here Update the current location and set "markerProviderLocation" marker.Once it will set it will update the current location.
                        
                        
                        self.arrviedView?.imagePickup.image = UIImage(named: "pickup-select")
                        
                        self.setValueForGoogleRetractionView(status: requestType.arrived.rawValue)
                        self.floatyButton?.removeFromSuperview()
                    case requestType.dropped.rawValue:
                        
                        self.viewGoogleRetraction.isHidden = true
                        
                        self.loader.isHidden = true
                        //self.loadAndShowArrivedNib()
                        self.gMSmapView.clear()
                        //MARK:- set Marker for dource and destination
                        if destinationLatitde != 0 && destinationLontitude != 0 {
                            self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                            
                            self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        }
                        self.getUserCurrentLocation()
                        self.loadAndInvoiceNib()
                        DispatchQueue.main.async {
                            self.setValueForInvoiceView(bookingId: bookingId, total: totalAmount ?? 0.0, paymentMode: paymentMode, payable: payable)
                        }
                        
                    case requestType.completed.rawValue:
                        self.loader.isHidden = true
                        self.seconds = 0
                        self.waitingFirstCall = true
                        DispatchQueue.main.async {
                            if self.requestDetail?.requests?[0].request?.paid == 0 && self.requestDetail?.requests?[0].request?.payment?.payment_mode == PaymentType.CASH.rawValue  {
                                self.loadAndInvoiceNib()
                                self.setValueForInvoiceView(bookingId: bookingId, total: totalAmount ?? 0.0, paymentMode: paymentMode, payable: payable)
                            }else{
                                self.inVoiceView?.dismissView(onCompletion: {
                                    self.inVoiceView = nil
                                })
                                self.loadRatingView()
                            }
                        }
                    default:
                        self.gMSmapView.clear()
                        self.getUserCurrentLocation()
                        self.showSimmerButton()
                        self.inVoiceView?.dismissView(onCompletion: {
                            self.inVoiceView = nil
                        })
                        self.rideAcceptViewNib?.dismissView(onCompletion: {
                            self.rideAcceptViewNib = nil
                        })
                        self.arrviedView?.dismissView(onCompletion: {
                            self.arrviedView = nil
                        })
                        self.OTPScreen?.dismissView(onCompletion: {
                            self.OTPScreen = nil
                        })
                        self.ratingViewNib?.dismissView(onCompletion: {
                            self.ratingViewNib = nil
                        })
                        break
                        
                    }
                    
                    //MARK:- Here Values are updated for Accept View
                    self.rideAcceptViewNib?.labelDropLocationValue.text = requestModel?.request?.d_address
                    self.rideAcceptViewNib?.pickUpLocation.text = requestModel?.request?.s_address
                    self.rideAcceptViewNib?.userName.text = requestModel?.request?.user?.first_name
                    self.rideAcceptViewNib?.viewRatings.value = CGFloat(userRating)
                }
                else {
                    AVPlayerHelper.player.stop()
                    self.view.removeBlurView()
                    self.viewGoogleRetraction.isHidden = true
                    self.loader.isHidden = true
                    self.gMSmapView.clear()
                    
                    self.showSimmerButton()
                    self.inVoiceView?.dismissView(onCompletion: {
                        self.inVoiceView = nil
                    })
                    self.rideAcceptViewNib?.dismissView(onCompletion: {
                        self.rideAcceptViewNib = nil
                    })
                    self.arrviedView?.dismissView(onCompletion: {
                        self.arrviedView = nil
                    })
                    self.OTPScreen?.dismissView(onCompletion: {
                        self.OTPScreen = nil
                    })
                    self.ratingViewNib?.dismissView(onCompletion: {
                        self.ratingViewNib = nil
                    })
                    self.viewGoogleRetraction.isHidden = true
                    self.waitingFirstCall = true
                    self.seconds = 0
                }
            }
            else if self.requestDetail?.account_status == AccountStatus.balance{
                self.backGroundInstanse.accountStatus = AccountStatus.balance
                self.hideSimmerButton()
                self.loadOfflineNib()
                self.removeDocumentsVC()
                self.removeCardVC()
                self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                self.view.bringSubviewToFront(self.offlineView)
            }
            else if self.requestDetail?.account_status == AccountStatus.onboarding {
                self.backGroundInstanse.accountStatus = AccountStatus.onboarding
                self.Simmer.setTitle(Constants.string.logout.localize(), for: .normal)
                self.loadOfflineNib()
                self.removeDocumentsVC()
                self.removeCardVC()
                self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                self.userOfflineView?.scrollTextVerified = true
                self.view.bringSubviewToFront(self.offlineView)
            }
            else if self.requestDetail?.account_status == AccountStatus.pendingCard {
                self.getPendingDocuments(from: Storyboard.Ids.AddCardViewController)
            }
            else if self.requestDetail?.account_status == AccountStatus.pendingDocument {
                self.getPendingDocuments(from: Storyboard.Ids.DocumentsTableViewController)
            }
            else {
                self.backGroundInstanse.accountStatus = AccountStatus.banned
                self.Simmer.setTitle(Constants.string.logout.localize(), for: .normal)
                self.loadOfflineNib()
                self.removeDocumentsVC()
                self.removeCardVC()
                self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                self.userOfflineView?.scrollTextVerified = true
                self.view.bringSubviewToFront(self.offlineView)
            }
        })
        
//        if self.accountStatus == .approved {
//            self.userOfflineView?.viewAutoScrollNotVerified.isHidden = true
//        }else if self.accountStatus == .balance {
//            self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
//            self.userOfflineView?.scrollTextVerified = false
//        }else {
//            self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
//            self.userOfflineView?.scrollTextVerified = true
//        }
        
        self.backGroundInstanse.destinationChanged = { details in
            showAlert(message: Constants.string.changeDestination.localize() + " " + (details.requests?.first?.request?.d_address)!, okHandler: { okHandle in
                self.gMSmapView.clear()
                //                self.labelPickupValue.text = self.requestDetail?.requests?.first?.request?.d_address
                self.labelPickupValue.text = details.requests?.first?.request?.d_address
                let sourceLatitude = (details.requests?.first?.request?.s_latitude)!
                let sourceLongitude = (details.requests?.first?.request?.s_longitude)!
                var desLatitude:Double = 0
                var desLongitude:Double = 0
                if details.requests?.first?.request?.d_latitude != nil && details.requests?.first?.request?.d_longitude != nil {
                    desLatitude = (details.requests?.first?.request?.d_latitude)!
                    desLongitude = (details.requests?.first?.request?.d_longitude)!
                    self.setMarker(sourceLat: sourceLatitude, sourceLong: sourceLongitude, destinationLat: desLatitude, destinationLong:desLongitude)
                    self.drawPoly(s_latitude: sourceLatitude, s_longtitude: sourceLongitude, d_latitude: desLatitude, d_longtitude: desLongitude)
                }
                
            }, fromView: self, isShowCancel: false, okTitle: Constants.string.OK.localize(), cancelTitle: Constants.string.no.localize())
            
        }
        
    }
    
    func checkServiceStatus(){
        // Simmer.setTitle(Constants.string.goOffline, for: .normal)
        self.userOfflineView?.isHidden = true
        self.removeOfflineView()
        
    }
    
    func setMarker(sourceLat: Double,sourceLong: Double,destinationLat: Double, destinationLong: Double){
        self.gMSmapView.clear()
        let source_CoOrdinate = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLong)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        self.plotSourceMarker(coordinate: source_CoOrdinate)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { //Extend Trip destination marker not update properly so added delay call
            self.plotDestinationMarker(coordinate:destinationCoordinate)
        }
        
    }
    
    private func plotSourceMarker(coordinate : CLLocationCoordinate2D){
        self.sourceMarker.position = coordinate
        self.sourceMarker.map = self.gMSmapView
        self.gMSmapView.animate(toLocation: coordinate)
    }
    
    func plotDestinationMarker(coordinate : CLLocationCoordinate2D) {
        self.destinationMarker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.destinationMarker.map = self.gMSmapView
    }
    
    func LoadUpdateStatusAPI(status: String,tollFee:Double){
        //self.loader.isHidden = false
        self.presenter?.post(api: .updateStatus, url: "\(Base.updateStatus.rawValue)/\(requestID)", data: MakeJson.UpdateTripStatus(tripStatus: status, latitude: location.value?.latitude ?? defaultMapLocation.latitude, longitude: location.value?.longitude ?? defaultMapLocation.longitude,tollFee: tollFee))
        //MakeJson.UpdateTripStatus(tripStatus: status)
    }
    
    func setValueForInvoiceView(bookingId : String?, total : Float?,paymentMode : String?, payable : Float?){
        let currency = UserDefaults.standard.value(forKey: Keys.list.currency)
        self.inVoiceView?.labeltotalValue.text = "\(currency ?? "$") \(total ?? 0)"
        self.inVoiceView?.labelBookingIDValue.text = bookingId
        self.inVoiceView?.labelCash.text = paymentMode
        self.inVoiceView?.labelAmountTobePaid.text = "\(currency ?? "$") \((payable ?? 0))"
        
    }
    private func plotMarker(marker : GMSMarker, with coordinate : CLLocationCoordinate2D){
        
        marker.position = coordinate
        marker.appearAnimation = .pop
        marker.icon = marker == self.sourceMarker ? #imageLiteral(resourceName: "Source").resizeImage(newWidth: 30) : #imageLiteral(resourceName: "destination").resizeImage(newWidth: 30)
        marker.map = self.gMSmapView//self.mapViewHelper?.mapView
        marker.map?.center = gMSmapView.center
        self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
    }
    
    func plotMoveMarker(marker: GMSMarker, with coordinate: CLLocationCoordinate2D, degree: CLLocationDegrees){
        marker.position = coordinate
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "pickup-select").resizeImage(newWidth: 30) // #imageLiteral(resourceName: "mapvehicle").resizeImage(newWidth: 30)
        marker.map = self.gMSmapView
        marker.rotation = degree
        marker.map?.center = self.gMSmapView.center
        self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
        
    }
    
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
        
        createPoly(index: pathIndex)
        for i in 0..<gmsPath.count(){
            //            let pathLat = Double(self.path.coordinate(at: i).latitude)
            let pathLat = gmsPath.coordinate(at: i).latitude.rounded(toPlaces: 3)
            let pathLong = gmsPath.coordinate(at: i).longitude.rounded(toPlaces: 3)
            
            let currentLat = currentLoc.latitude.rounded(toPlaces: 3)
            let currentLong = currentLoc.longitude.rounded(toPlaces: 3)
            
            
            if currentLat == pathLat && currentLong == pathLong{
                pathIndex = Int(i)
                break   //Breaking the loop when the index found
            }
        }
    }
    
    func createPoly(index :Int){
        
        //Creating new path from the current location to the destination
        let newPath = GMSMutablePath()
        if Int(gmsPath.count()) > index {
            for i in index..<Int(gmsPath.count()){
                newPath.add(gmsPath.coordinate(at: UInt(i)))
            }
            gmsPath = newPath
            polyLinePath.map = nil
            polyLinePath = GMSPolyline(path: gmsPath)
            polyLinePath.strokeColor = .primary
            polyLinePath.strokeWidth = 3.0
            polyLinePath.map = self.mapViewHelper?.mapView
        }
    }
    
    func checkPolyline(coordinate: CLLocationCoordinate2D)  {
        guard polyLinePath.path != nil else {
            return
        }
        if GMSGeometryIsLocationOnPathTolerance(coordinate, polyLinePath.path!, true, 100.0)
        {
            print("=== true")
            isRerouteEnable = false
        }
        else
        {
            isRerouteEnable = true
            print("=== false")
        }
    }
    
    private func loadAcceptAPI(){
        self.loader.isHidden = false
        presenter?.post(api: .acceptRequest, url: "\(Base.acceptRequest.rawValue)\(requestID)", data: nil)
        
    }
    
    func setValueForArrivedView(){
        self.arrviedView?.userName.text = self.requestDetail?.requests?.first?.request?.user?.first_name
        rideAcceptViewNib?.showAnimateView(rideAcceptViewNib!, isShow: false, direction: Direction.Bottom)
        self.arrviedView?.labelAddress.text = self.requestDetail?.requests?.first?.request?.s_address
        // setValueForGoogleRetractionView(address: self.requestDetail?.requests?.first?.request?.d_address ?? "", tripState: .arrived)
        
        self.arrviedView?.lablelPickup.text = Constants.string.pickUp.localize()
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(self.userProfile)" , completion: { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.arrviedView?.userProfile.image = image
                }
            }
        })
        
        self.arrviedView?.labelDrop.text = Constants.string.dropLocation.localize()
        self.arrviedView?.labelDropValue.text = self.requestDetail?.requests?.first?.request?.d_address
        
        let rating = self.requestDetail?.requests?.first?.request?.user?.rating
        let ratingInt = Double(rating ?? "0")
        // let swe = Double(rating!)
        // print("UserRaying: .\(ratingInt)")
        self.arrviedView?.ratingView.value = CGFloat(ratingInt ?? 0)  //Float(ratingInt ?? 3)
        self.arrviedView?.ratingView.maximumValue = 5
    }
    
    private func  setValueForGoogleRetractionView(status: String?){
        if status == requestType.started.rawValue {
            self.labelPickUp.text = Constants.string.pickUpLocation.localize()
            self.labelPickupValue.text = self.requestDetail?.requests?.first?.request?.s_address
        }else if  status == requestType.arrived.rawValue{
            self.labelPickUp.text = Constants.string.dropLocation.localize()
            self.labelPickupValue.text = self.requestDetail?.requests?.first?.request?.d_address
        }else{
            
        }
        
    }
    
    private func loadLocationAPI(){
        
        let user = User()
        
        self.presenter?.post(api: .updateLocation, data: MakeJson.updateLoaction(latitute: user.latitude , lontitute: user.lontitude))
        
    }
    
    private func GetOnlineStatus(status: String){
        
        self.presenter?.post(api: .onlineStatus, data: MakeJson.OnlineStatus(status: status))
    }
    
    
    // MARK:- Show Cancel Reason View
    
    private func showCancelReasonView(completion : @escaping ((String)->Void)) {
        
        if self.reasonView == nil, let reasonView = Bundle.main.loadNibNamed(XIB.Names.ReasonView, owner: self, options: [:])?.first as? ReasonView {
            reasonView.frame = CGRect(x: 16, y: 50, width: self.view.frame.width-32, height: reasonView.frame.height)
            self.reasonView = reasonView
            self.reasonView?.didSelectReason = { cancelReason in
                completion(cancelReason)
            }
            reasonView.set(value: self.cancelReason)
            self.view.addSubview(reasonView)
            self.reasonView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.5),
                           initialSpringVelocity: CGFloat(1.0),
                           options: .allowUserInteraction,
                           animations: {
                            self.reasonView?.transform = .identity },
                           completion: { Void in()  })
        }
        self.reasonView?.onClickClose = { _ in
            self.reasonView?.removeFromSuperview()
            self.reasonView = nil
        }
    }
    
    // MARK:- Remove Cancel View
    
    private func removeCancelView() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.reasonView?.transform = CGAffineTransform(scaleX: 0.0000001, y: 0000001)
        }) { (_) in
            self.reasonView?.removeFromSuperview()
            self.reasonView = nil
        }
    }
    
    
    
    private func setGooglemap(){
        
        self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getCurrentLocation)))
        print(BackGroundTask.backGroundInstance.userStoredDetail.lontitude ?? 91.00)
        let coOrdinates = CLLocationCoordinate2D(latitude: BackGroundTask.backGroundInstance.userStoredDetail.latitude ?? 13.0827, longitude: BackGroundTask.backGroundInstance.userStoredDetail.lontitude ?? 80.2707)
        gMSmapView.camera = GMSCameraPosition(target: coOrdinates, zoom: 15, bearing: 10.00, viewingAngle: 10.00)
        
        gMSmapView.delegate = self
        Simmer.tintColor = UIColor.white
        Simmer.backgroundColor = UIColor.black
    }
    
    @IBAction private func getCurrentLocation(){
        if BackGroundTask.backGroundInstance.userStoredDetail.latitude != nil {
            
            UIView.animate(withDuration: 1) {
                let coOrdinates = CLLocationCoordinate2D(latitude: BackGroundTask.backGroundInstance.userStoredDetail.latitude!, longitude: BackGroundTask.backGroundInstance.userStoredDetail.lontitude!)
                self.gMSmapView.isMyLocationEnabled = true
                self.gMSmapView.animate(to: GMSCameraPosition(target: coOrdinates, zoom: 15, bearing: 10.00, viewingAngle: 10.00))
            }
        }
        
    }
    
    private func simmerBtnAction(){ //MARK:- set Action for Go Online and offline view
        self.Simmer.addTarget(self, action: #selector(simmerBtnTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func simmerBtnTapped(sender: UIButton){
        
        
        if requestDetail?.account_status == AccountStatus.approved || requestDetail?.account_status == AccountStatus.balance{
            self.initimateServiceStatusBackend()
        }else {
            self.logout()
        }
    }
    
    // Intitmating Backend on service status
    
    private func initimateServiceStatusBackend() {
        
        self.loader.isHidden = false
        let status : ServiceStatus = self.onlineStatus == .ONLINE ? .OFFLINE : .ONLINE
        self.GetOnlineStatus(status: status.rawValue)
        self.onlineStatus = status
    }
    
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.logoutMessage.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            //self.loader.isHidden = false
            self.presenter?.post(api: .logout, data: nil)
            BackGroundTask.backGroundInstance.stopBackGroundTimer()
            BackGroundTask.backGroundInstance.backGroundTimer.invalidate()
            
            BackGroundTask.backGroundInstance.onbordingStatus = ""
            BackGroundTask.backGroundInstance.approvedStatus = ""
            BackGroundTask.backGroundInstance.bannedStatus = ""
            
        }
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.view.tintColor = .primary
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func addBlurView(){
        let blurView  = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffedView = UIVisualEffectView(effect: blurView)
        blurEffedView.frame = view.bounds
        self.offlineView.backgroundColor = UIColor.clear
        self.offlineView.addSubview(blurEffedView)
        self.offlineView.addSubview(offlineImage)
        
    }
    
    func animateIn() {
        
        
        
        rideAcceptViewNib?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        rideAcceptViewNib?.alpha = 0
        
        UIView.animate(withDuration: 2) {
            
            self.rideAcceptViewNib?.alpha = 1
            
            self.rideAcceptViewNib?.transform = CGAffineTransform.identity
            self.rideAcceptViewNib?.isHidden = false
        }
        
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.offlineView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.offlineView.alpha = 0
            
        }) { (success:Bool) in
            self.offlineView.isHidden = true
            
        }
    }
    
    private func addTapGusture(){ //MARK:- tapGusture added for left Menu
        let menuTapGusture = UITapGestureRecognizer(target: self, action: #selector(menuTapped(sender:)))
        self.menuBackView.addGestureRecognizer(menuTapGusture)
    }
    
    @objc private func menuTapped(sender: UITapGestureRecognizer){
        //sender.view?.addPressAnimation()
//        vibrate(sound: .pop)
        self.drawerController?.openSide(selectedLanguage == .arabic ? .right : .left)
        
    }
    
    
    func startTimer(){ //MARK:- Here set the timer value for accept request counter
        
        AVPlayerHelper.player.play()
        
        print("Called",#function)
        self.timer?.invalidate()
        self.timer = nil
        self.timeSecond = 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { ( timer ) in
            
            self.timeSecond -= 1
            print("Timer Value ",self.timeSecond)
            if self.timeSecond == 0 {
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                    AVPlayerHelper.player.stop()
                    self.rideAcceptViewNib?.dismissView(onCompletion: {
                        self.rideAcceptViewNib = nil
                        self.Simmer.showAnimateView(self.Simmer, isShow: true, direction: .Top)
                        self.backSimmerBtnView.showAnimateView(self.backSimmerBtnView, isShow: true, direction: .Top)
                    })
                    
                }
                print("Invalidated")
                
            }
            self.rideAcceptViewNib?.labelTime.text = "\(self.timeSecond)"
        })
        
        
        
    }
    
    @objc func acceptBtnTapped(sender: UIButton){
        AVPlayerHelper.player.stop()
        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
        // self.rideAcceptViewNib?.viewRequest.isHidden = true
        self.timer?.invalidate()
        self.timer = nil
        self.loadAcceptAPI()//MARK:- here load the accept API
        if self.isScheduled {
            if let yourTripsVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.yourTripsPassbookViewController) as? YourTripsPassbookViewController {
                yourTripsVC.isYourTripsSelected = true
                yourTripsVC.isFirstBlockSelected = false
            }
        }
    }
    
    @objc func rejectBtnTapped(sendre: UIButton){
        AVPlayerHelper.player.stop()
        self.loader.isHidden = false
        rejectAPI()
        self.timer?.invalidate()
        self.timer = nil
        self.rideAcceptViewNib?.showAnimateView(self.rideAcceptViewNib!, isShow: false, direction: Direction.Bottom)
    }
    
    private func rejectAPI(){
        //        self.presenter?.post(api: .reject, url: "\(Base.reject.rawValue)\(String(describing: self.requestID!))", data: nil)
        self.presenter?.delete(api: .reject, url: "\(Base.reject.rawValue)\(self.requestID)", data: nil)
    }
    
    @IBAction func invoiceConfirmButtontapped(sender: UIButton){
        if self.requestDetail?.requests?[0].request?.paid == 0 {
            self.LoadUpdateStatusAPI(status: Constants.string.completed, tollFee: 0)
            self.loadRatingView()
        }
        else {
            //self.inVoiceView?.removeFromSuperview()
            self.loader.isHidden = false
            self.loadRatingView()
            self.LoadUpdateStatusAPI(status: Constants.string.completed, tollFee: 0)
        }
        
        
    }
    
    func loadRatingAPI(comment: String?, Ratings: Int){ //MARK:- here set load the rating API
        self.loader.isHidden = false
        self.presenter?.post(api: .invoiceAPI, url: "\(Base.invoiceAPI.rawValue)\(self.requestID)/rate", data: MakeJson.invoiceUpdate(rating: Ratings, comment: comment))
    }
    
    @objc  func startprogressbar(){
        
        self.arrviedView?.progressBarArrivedToPickUp.progress += 0.2
        
    }
    
    @objc func startPickupToDropProgess(){
    
    }
    
    
    
    @objc  func cancelBtnTapped(sender: UIButton){
        self.cancelCurrentRide(isSendReason: true)
    }
    
    // Cancel Request
    
    func cancelRequest(reason : String? = nil) {
        var cancelModel = UpcomingCancelModel()
        cancelModel.id = requestID
        cancelModel.cancel_reason = reason
        self.presenter?.post(api: .UpcommingCancel, data: cancelModel.toData())
    }
    
    @objc  func arrivedButtontapped(sender: UIButton){
        
        let requestModel = self.requestDetail?.requests![0]
        let requestStatus = requestModel?.request?.status
        
        if requestStatus == requestType.arrived.rawValue {
            self.loader.isHidden = true
            if User.main.ride_otp == 1 {
                self.loadOtpScreen()
            }
            else {
                self.LoadUpdateStatusAPI(status: Constants.string.pickedUp, tollFee: 0)
                self.statusChanged(status: requestType.pickedUp.rawValue, tollFee: 0)
            }
        }
        else if requestStatus == requestType.pickedUp.rawValue {
            showTollView()
        }
        else {
            self.loader.isHidden = false
            self.statusChanged(status: requestType.arrived.rawValue, tollFee: 0.0)
        }
        
    }
    
    
    func showTollView() {
        if self.tollView == nil, let tollView = Bundle.main.loadNibNamed(XIB.Names.TollFeeView, owner: self, options: [:])?.first as? TollFeeView {
            //(self.view.frame.height/2)-(tollView.frame.height/2)
            tollView.frame = CGRect(x: 20, y:(((UIApplication.shared.keyWindow?.frame.size.height)!/2)-(tollView.frame.height/2)), width: self.view.frame.width-40, height: tollView.frame.height)
            self.tollView = tollView
            
            UIApplication.shared.keyWindow?.addSubview(tollView)
            self.tollView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.5),
                           initialSpringVelocity: CGFloat(1.0),
                           options: .allowUserInteraction,
                           animations: {
                            self.tollView?.transform = .identity },
                           completion: { Void in()  })
        }
        self.tollView?.onClickDismiss = { tollFee,isDismiss in
            self.loader.isHidden = false
            if isDismiss {
                self.statusChanged(status: requestType.dropped.rawValue, tollFee: 0.0)
            }
            else {
                self.statusChanged(status: requestType.dropped.rawValue, tollFee: Double(tollFee)!)
            }
            self.tollView?.removeFromSuperview()
            self.tollView = nil
            
        }
    }
    
    // MARK:- Cancel Current Ride
    
    private func cancelCurrentRide(isSendReason : Bool = false) {
        
        
        showAlert(message: Constants.string.cancelRequest.localize(), okHandler: { okHandle in
            if okHandle {
                if isSendReason {
                    self.showCancelReasonView(completion: { (reason) in  // Getting Cancellation Reason After Providing Accepting Ride
                        cancelRide(reason: reason)
                        self.removeCancelView()
                    })
                    
                    //                cancelRide()
                } else {
                    cancelRide()
                }
            }
            
        },fromView: self, isShowCancel: true, okTitle: Constants.string.yes.localize(), cancelTitle: Constants.string.no.localize())
        
        func cancelRide(reason : String? = nil) { // Cancel Ride
            self.cancelRequest(reason: reason)
        }
        
        
    }
    
    func statusChanged(status : String,tollFee:Double){ //MARK:- changing the button name occurding to the request status
        switch status {
        case requestType.arrived.rawValue:
            self.LoadUpdateStatusAPI(status: Constants.string.arrived, tollFee: 0)
            self.view.removeBlurView()
            //  self.OTPScreen?.removeFromSuperview()
            //            self.arrviedView?.viewMessage.isHidden = true
            self.arrviedView?.arrivedBtn.setTitle( Constants.string.pickedUp.localize().uppercased(), for: .normal)
            self.arrviedView?.hideWaitingTime = true
        case requestType.pickedUp.rawValue:
            self.OTPScreen?.removeFromSuperview()
            self.view.removeBlurView()
            self.LoadUpdateStatusAPI(status: Constants.string.pickedUp, tollFee: 0)
            self.arrviedView?.arrivedBtn.setTitle(Constants.string.tapWhenDropped.localize(), for: .normal)
            self.arrviedView?.cancelBtn.alpha = 1.0
            self.arrviedView?.hideWaitingTime = false
            UIView.animate(withDuration: 0.5, animations: {
                self.arrviedView?.cancelBtn.alpha = 0.0
                self.arrviedView?.cancelBtn.isHidden = true
            }) { (_) in
            }
        case requestType.dropped.rawValue:
            self.LoadUpdateStatusAPI(status: Constants.string.dropped, tollFee: tollFee)
            self.arrviedView?.hideWaitingTime = true
            
        default:
            print("default")
        }
        
    }
    
    private func setTitleForButton(status : String){
        switch status {
        case requestType.arrived.rawValue:
            self.view.removeBlurView()
            self.arrviedView?.arrivedBtn.setTitle( Constants.string.pickedUp.localize().uppercased(), for: .normal)
            
            break
        case requestType.pickedUp.rawValue:
            self.view.removeBlurView()
            self.arrviedView?.arrivedBtn.setTitle(Constants.string.tapWhenDropped.localize(), for: .normal)
            self.arrviedView?.cancelBtn.alpha = 1.0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.arrviedView?.cancelBtn.alpha = 0.0
                self.arrviedView?.cancelBtn.isHidden = true
            }) { (_) in
            }
            break
        case requestType.dropped.rawValue:
            break
            
            
        default:
            print("default")
        }
    }
    
    private func setSubView(){ //MARK:- here set the "viewGoogleRetraction" subView for google Map view
        self.gMSmapView.addSubview(viewGoogleRetraction)
        
    }
}

extension HomepageViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) { //MARK:-error state
        print(message)
        self.loader.isHideInMainThread(true)
    }
    
    func getLoactionUpadate(api: Base, data: updateLocationModelResponse?) { //MARK:-update location of the provider
        print("location update: \(String(describing: data?.message))")
    }
    
    func getOnlineStatus(api: Base, data: OnlinestatusModelResponse?) { //MARK:-Update Online ,Offline Status of provider
        self.loader.isHidden = true
        if data?.error == ErrorMessage.list.yourAccountNotVerified {
            self.onlineStatus = ServiceStatus.OFFLINE
            self.loadOfflineNib()
            self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
            self.userOfflineView?.scrollTextVerified = true
        }
        else if data?.service?.status == .ONLINE {
            //MARK:-self.userOfflineView?.showAnimateView(self.userOfflineView!, isShow: false, direction: .Bottom)
            self.onlineStatus = .ONLINE
            AVPlayerHelper.player.stop()
            self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (locationCoordinate) in
                self.location.value = locationCoordinate.coordinate
                self.latestLocation = locationCoordinate
            })
            self.removeOfflineView()
        }else {
            self.onlineStatus = .OFFLINE
            self.loadOfflineNib()
        }
        self.getUserCurrentLocation()
    }
    
    func GetAcceptStatus(api: Base, data: [AcceptModelReponse]?) { //MARK:-Ride accept function
        
        
    }
    
    func getUpdateStatus(api: Base, data: UpdateTripStatusModelResponse?) { //MARK:-Ride Upadte function. here getting the response for updateStatus API
        print(data as Any)
    }
    
    
    func getRejectAPI(api: Base, data: [RejectModelResponse]?) { //MARK:-Ride reject Function
        self.loader.isHidden = true
        self.arrviedView?.showAnimateView(self.arrviedView!, isShow: false, direction: Direction.Bottom)
        print(data as Any)
    }
    
    func getInvoiceData(api: Base, data: InvoiceModelResponse?) { //MARK:-Invoice API response function
        self.loader.isHideInMainThread(true)
        self.ratingViewNib?.showAnimateView(self.ratingViewNib!, isShow: false, direction: .Bottom)
        self.Simmer.showAnimateView(self.Simmer, isShow: true, direction: .Top)
        self.backSimmerBtnView.showAnimateView(self.backSimmerBtnView, isShow: true, direction: .Top)
        print(data?.message as Any)
    }
    
    func getSucessMessage(api: Base, data: String?) {
        if api == .logout {
            forceLogout()
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        Common.storeUserData(from: data)
        storeInUserDefaults()
    }
    
    func getReason(api: Base, data: [ReasonEntity]) {
        self.cancelReason = data
    }
    
    func getWaitingTime(api: Base, data: WaitingTime) {
        print(data)
        print("Called Waiting")
        self.isTimerRunning = data.waitingStatus == 1
        self.seconds = data.waitingTime ?? 0
        if self.waitingFirstCall {
            self.waitingFirstCall = false
            self.setWaitingView()
            
        }
        
    }
    
}

