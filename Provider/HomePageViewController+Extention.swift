//
//  HomePageViewController+Extention.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import UIKit
import Floaty

//MARk:- All External XIB file are loaded here

extension HomepageViewController {

    //MARK:- load Offline View
     func loadOfflineNib(){
        
        if self.userOfflineView == nil,let userofflineView = Bundle.main.loadNibNamed(XIB.Names.offlineView, owner: self, options: nil)?.first as? offlineView{
            self.userOfflineView = userofflineView
        self.userOfflineView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //self.userOfflineView?.showAnimateView(self.userOfflineView!, isShow: true, direction: .Top)
         self.userOfflineView?.viewAutoScrollNotVerified.isHidden = true
            self.animateIn()
        self.view.addSubview(userOfflineView!)
        self.view.addSubview(backSimmerBtnView)
        self.view.addSubview(Simmer)
        self.view.addSubview(menuBackView)
        self.view.addSubview(Menuimage)
        }
        
    }
    
    // MARK:- Remove Offline View
    
    func removeOfflineView() {
        self.userOfflineView?.dismissView(onCompletion: {
            self.userOfflineView = nil
        })
    }
    
    //MARK:- load OTPScreen
    func loadOtpScreen(){
       
        guard self.OTPScreen == nil else {
            return
        }
        
        self.view.addBlurview { blurView in
            self.hideSimmerButton()
            self.OTPScreen = Bundle.main.loadNibNamed(XIB.Names.OTPScreenView, owner: self, options: nil)?.first as? OTPScreenView
            self.OTPScreen?.frame = CGRect(x: 0, y: self.view.frame.height / 3, width: self.view.frame.width, height: 200)
            blurView?.contentView.addSubview(self.OTPScreen!)
            blurView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.otpScreenPanGesture(sender:))))
            self.OTPScreen?.set(number: self.userOtp ?? "0", with: { (status) in
                
                if status{
                    self.LoadUpdateStatusAPI(status: Constants.string.pickedUp, tollFee: 0)
                    self.statusChanged(status: requestType.pickedUp.rawValue, tollFee: 0)
                }else {
                    
                }
            })
        }
    }
    
    func loadRatingView (){ //Laod Rating View XIB file
        self.loader.isHidden = true
        if self.inVoiceView != nil {
            self.inVoiceView?.showAnimateView(self.inVoiceView!, isShow: false, direction: .Bottom)
            self.inVoiceView?.dismissView(onCompletion: {
                self.inVoiceView = nil
            })
        }
    
        if self.ratingViewNib == nil, let ratingViewBundle =  Bundle.main.loadNibNamed(XIB.Names.ratingView, owner: self, options: nil)?.first as? RatingView {
            self.ratingViewNib = ratingViewBundle
            self.ratingViewNib?.frame = CGRect(x: 0, y: self.view.frame.height - (self.ratingViewNib?.frame.height)!, width: self.view.frame.width, height: 250)
            
            self.ratingViewNib?.onclickRating = { rating, comments in
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                StoreReview.review()
                var commentStr = ""
                if comments != Constants.string.writeYourComments {
                    commentStr = comments
                }
                self.loadRatingAPI(comment: commentStr, Ratings: rating)
            }
            
            self.view.addSubview(self.ratingViewNib!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowRateView(info:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideRateView(info:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        self.setValueForRatingView()
     
    }
    private func setValueForRatingView(){
        
        self.ratingViewNib?.labelRating.text = "\(Constants.string.rateyourtrip.localize()) \(self.requestDetail?.requests?.first?.request?.user?.first_name ?? "--")"
        
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(self.userProfile)" , completion: { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.ratingViewNib?.imageViewProvider.image = image
                }
            }
        })
    }
    
    
    func loadAcceptNib(){ //Load Accept View XIB file
        
        self.loader.isHidden = true
        self.hideSimmerButton()
    
        //self.userOfflineView?.isHidden = true
        self.Simmer.isHidden = true
        self.backSimmerBtnView.isHidden = true
        
        if self.rideAcceptViewNib == nil, let rideAcceotBundle =  Bundle.main.loadNibNamed(XIB.Names.RideAcceptView, owner: self, options: nil)?.first as? RideAcceptView{
            self.rideAcceptViewNib = rideAcceotBundle
            self.rideAcceptViewNib?.showAnimateView(rideAcceptViewNib!, isShow: true, direction: Direction.Top)
            let yPosition = self.view.frame.height - (self.rideAcceptViewNib?.viewVisualEffect.frame.height)!
            
            self.rideAcceptViewNib?.frame = CGRect(x: 0, y: yPosition , width: self.view.frame.width, height: (self.rideAcceptViewNib?.viewVisualEffect.frame.height)!)
            
            self.view.addSubview(self.rideAcceptViewNib!)
            
            self.rideAcceptViewNib?.AcceptBtn.addTarget(self, action: #selector(acceptBtnTapped(sender:)), for: .touchUpInside)
            self.rideAcceptViewNib?.RejectBtn.addTarget(self, action: #selector(rejectBtnTapped(sendre:)), for: .touchUpInside)
        }
    }
    
   
    
    func loadAndShowArrivedNib(){ //Show arrived view
        
        self.loader.isHidden = true
        self.hideSimmerButton()
        if self.arrviedView == nil, let arrivedBundle = (Bundle.main.loadNibNamed(XIB.Names.rideArrivedView, owner: self, options: nil)?.first as? rideArrivedView) {
            
            self.arrviedView = arrivedBundle
            
//            self.arrviedView?.viewMessage.tag = 1
//            self.arrviedView?.callImage.tag = 2
            
            self.arrviedView?.frame = CGRect(x: 0, y:self.view.frame.height - arrivedBundle.viewVisualEffect.frame.height, width: self.view.frame.width, height: arrivedBundle.viewVisualEffect.frame.height)
//            let gusture = UITapGestureRecognizer(target:self,action: #selector(callImageTapped(sender:)))
//            let messageGesture = UITapGestureRecognizer(target: self, action: #selector(callImageTapped(sender:)))
//            self.arrviedView?.viewMessage.addGestureRecognizer(messageGesture)
//            self.arrviedView?.callImage.isUserInteractionEnabled = true
//            self.arrviedView?.callImage.addGestureRecognizer(gusture)
            self.arrviedView?.btnWaitingTime.addTarget(self, action: #selector(tapWaitingTime), for: .touchUpInside)
            self.addFloatingButton(with: (self.arrviedView?.frame.height)!)
            self.arrviedView?.showAnimateView(arrviedView!, isShow: true, direction: Direction.Top)
            self.view.addSubview(self.arrviedView!)
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(HomepageViewController.startprogressbar), userInfo: nil, repeats: true)
            self.arrviedView?.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(sender:)), for: .touchUpInside)
            self.arrviedView?.arrivedBtn.addTarget(self, action: #selector(arrivedButtontapped(sender:)), for: .touchUpInside)
            
        }
        
        setValueForArrivedView()
        
    }
    
    
    
    func loadAndInvoiceNib(){ //Show arrived view
        
        self.hideSimmerButton()
        self.arrviedView?.removeFromSuperview()
        self.loader.isHidden = true
        if self.inVoiceView == nil, let invoicebundle = (Bundle.main.loadNibNamed(XIB.Names.invoiceView, owner: self, options: nil)?.first as? invoiceView){
            self.inVoiceView = invoicebundle
            self.inVoiceView?.frame = CGRect(x: 0, y:self.view.frame.height - self.inVoiceView!.viewVisualEffect.frame.height, width: self.view.frame.width, height: self.inVoiceView!.viewVisualEffect.frame.height)
            self.arrviedView?.viewVisualEffectMain.showAnimateView((self.arrviedView?.viewVisualEffectMain)!, isShow: false, direction: .Bottom)
            self.inVoiceView?.viewVisualEffect.showAnimateView((self.inVoiceView?.viewVisualEffect)!, isShow: true, direction: .Top)
            self.inVoiceView?.buttonConfirm.addTarget(self, action: #selector(invoiceConfirmButtontapped(sender:)), for: .touchUpInside)
            self.view.addSubview(self.inVoiceView!)
        }
    }
    
    
    @IBAction func otpScreenPanGesture(sender: UIPanGestureRecognizer){
        
        let threshold : CGFloat = (UIScreen.main.bounds.height/3)
        guard let senderView = sender.view else {return}
        var translation = sender.translation(in: self.view).y
        //guard translation.y < 0 else { return }
        UIView.animate(withDuration: 0.5) {
            self.OTPScreen?.center = CGPoint(x: (self.OTPScreen?.center.x)!, y: (self.OTPScreen?.center.y)! + translation)
        }
        translation = abs(translation)
        
        func removeView(){
            if translation >= threshold {
                UIView.animate(withDuration: 0.5, animations: {
                    senderView.alpha = 0
                }) { (_) in
                    senderView.removeFromSuperview()
                    self.OTPScreen = nil
                }
            }
        }
        
        if sender.state == .changed {
            removeView()
        } else if sender.state == .ended  {
            if (translation < threshold ) {
                UIView.animate(withDuration: 0.5) {
                    self.OTPScreen?.center = CGPoint(x: senderView.frame.width/2, y: senderView.frame.height/2)
                }
            } else {
                removeView()
            }
        }
        
        print("Translation  - ",translation, " -    ",threshold)
        

    /*    self.view.bringSubview(toFront: self.OTPScreen!)
        let translation = sender.translation(in: self.OTPScreen)
        print("translation: \(translation.y)")
        UIView.animate(withDuration: 0.5) {
             self.OTPScreen?.center = CGPoint(x: (self.OTPScreen?.center.x)!, y: (self.OTPScreen?.center.y)! + translation.y)
        }
        guard translation.y > 0 else { return }
        
        //self.OTPScreen?.center = CGPoint(x: (self.OTPScreen?.center.x)!, y: (self.OTPScreen?.center.y)! + translation.y)
        switch sender.state {
        case .began:
            print("began")
            break
        case .cancelled:
            print("cancelled")
            break
        case .changed:
            print("changed")
            break
        case .ended:
            print("end")
            if translation.y >= 100.0 {
                print("dismiss")
                self.view.removeBlurView()
                self.OTPScreen?.dismissView(onCompletion: {
                    self.OTPScreen = nil
                })
                //self.inVoiceView?.showAnimateView(self.inVoiceView!, isShow: false, direction: .Bottom)
            }else {
                print("up")
            }
//            self.view.removeBlurView()
//            self.OTPScreen?.dismissView(onCompletion: {
//                self.OTPScreen = nil
//            })
           // self.inVoiceView?.showAnimateView(self.inVoiceView!, isShow: false, direction: .Bottom)
            break
        case .failed:
            print("faild")
            break
        case .possible:
            print("possible")
            break
        default:
            print("default")
            break
        }
      
        //sender.setTranslation(CGPoint.zero, in: self.view) */
    }
    
    func hideSimmerButton(){
        self.Simmer.isHidden = true
        self.backSimmerBtnView.isHidden = true
    }
    
    func showSimmerButton(){
        if Simmer.isHidden == true{
            self.Simmer.showAnimateView(self.Simmer, isShow: true, direction: .Top)
            self.backSimmerBtnView.showAnimateView(self.backSimmerBtnView, isShow: true, direction: .Top)
        }
    }
    //MARK:- Keyboard will show
    
    @IBAction func keyboardWillShowRateView(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.ratingViewNib?.frame.origin.y =  keyboard.origin.y-(self.ratingViewNib?.frame.height ?? 0 )
    }
    
    
    //MARK:- Keyboard will hide
    
    @IBAction func keyboardWillHideRateView(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.ratingViewNib?.frame.origin.y += keyboard.size.height
        
    }

    
    @IBAction func callImageTapped(sender: UITapGestureRecognizer){ //not used
        if sender.view?.tag == 1 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SingleChatController) as? SingleChatController {
                vc.set(user: self.requestDetail!, requestId: self.requestID)
                let navigation = UINavigationController(rootViewController: vc)
                self.present(navigation, animated: true, completion: nil)
            }
        }else{
             makeCall(phoneNumber: String(userPhoneNumber))
        }
    }
    
    @objc func tapWaitingTime(){
        print("Called")
        var waitingEntity = WaitingTime()
        waitingEntity.id = self.requestDetail?.requests![0].request?.id ?? 0
        if !waitingFirstCall {
            if isTimerRunning == false {
                runTimer()
                waitingEntity.status = 1
                self.arrviedView?.btnWaitingTime.backgroundColor = .primary
            }else{
                self.waitingTimer?.invalidate()
                self.waitingTimer = nil
                isTimerRunning = false
                waitingEntity.status = 0
                self.arrviedView?.btnWaitingTime.backgroundColor = .lightGray
            }
        }
        self.presenter?.post(api: .waitingTime, data: waitingEntity.toData())
    }
    
    func setWaitingView()  {
        if isTimerRunning {
            self.arrviedView?.btnWaitingTime.backgroundColor = .primary
            runTimer()
        }
        self.arrviedView?.labelWaitingTimer.text = timeString(time: TimeInterval(self.seconds))
    }
    
    
    func runTimer() {
       
        waitingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { ( timer ) in
            self.seconds += 1
            self.arrviedView?.labelWaitingTimer.text = timeString(time: TimeInterval(self.seconds))
            self.isTimerRunning = true
        })
        
    }
    
    
    // MARK:- Add Floating Button
    
    private func addFloatingButton(with padding : CGFloat) {
        
        if self.requestID != 0 {
            let floaty = Floaty()
            floaty.plusColor = .primary
            floaty.hasShadow = false
            floaty.autoCloseOnTap = true
            floaty.buttonColor = .white
            floaty.buttonImage = #imageLiteral(resourceName: "phoneCall").withRenderingMode(.alwaysTemplate).resizeImage(newWidth: 25)
            floaty.paddingY = padding + 5
            floaty.itemImageColor = .secondary
            let callImage:UIImage = #imageLiteral(resourceName: "call").imageTintColor(color1: .primary)
            floaty.addItem(icon: callImage.resizeImage(newWidth: 25)) { (_) in
                makeCall(phoneNumber: String(self.userPhoneNumber))
            }
            let chatImage:UIImage = #imageLiteral(resourceName: "message").imageTintColor(color1: .primary)
            floaty.addItem(icon: chatImage.resizeImage(newWidth: 25)) { (_) in
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SingleChatController) as? SingleChatController {
                    vc.set(user: self.requestDetail!, requestId: self.requestID)
                    let navigation = UINavigationController(rootViewController: vc)
                    self.present(navigation, animated: true, completion: nil)
                }
            }
            self.view.bringSubviewToFront(self.arrviedView!)
            self.floatyButton = floaty
            self.view.addSubview(floaty)
        }
    }
    
    // MARK:- Share Items
    
    func share(items : [Any]) {
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    func setValueForGoogleRetractionView(address: String, tripState: requestType){
        self.labelPickupValue.text = address
        if tripState.rawValue == requestType.started.rawValue {
            self.labelPickUp.text = Constants.string.pickUpLocation.localize()
        }else {
            self.labelPickUp.text = Constants.string.dropLocation.localize()
        }
    }
    
    // MARK:- Present Viewcontroller for Pending Files
    
    func getPendingDocuments(from viewcontrollerId : String) {
        
        let vc = Router.main.instantiateViewController(withIdentifier: viewcontrollerId)
        if type(of: vc) == DocumentsTableViewController.self {
            (vc as! DocumentsTableViewController).isGettingDocuments = true
            self.removeCardVC()
            if self.documentController == nil {
                self.documentController = UINavigationController(rootViewController: vc)
                present(self.documentController!, animated: true, completion: nil)
            }
        }
        else if type(of: vc) == AddCardViewController.self {
            (vc as! AddCardViewController).isGettingDocuments = true
            self.removeDocumentsVC()
            if self.addCardVC == nil {
                self.addCardVC = UINavigationController(rootViewController: vc)
                present(self.addCardVC!, animated: true, completion: nil)
            }
        }
    }
}
