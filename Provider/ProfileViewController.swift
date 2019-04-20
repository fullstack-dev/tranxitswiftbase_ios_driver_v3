//
//  ProfileViewController.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit

class ProfileViewController: UITableViewController {
    
    // MARK:- IBOutlet

    @IBOutlet private weak var viewImageChange : UIView!
    @IBOutlet private weak var imageViewProfile : UIImageView!
    @IBOutlet private weak var textFieldFirst : HoshiTextField!
    @IBOutlet private weak var textFieldLast : HoshiTextField!
    @IBOutlet private weak var textFieldPhone : HoshiTextField!
    @IBOutlet private weak var textFieldEmail : HoshiTextField!
    @IBOutlet private weak var buttonSave : UIButton!
    @IBOutlet private weak var buttonChangePassword : UIButton!
    @IBOutlet private weak var labelBusiness : UILabel!
    @IBOutlet private weak var labelPersonal : UILabel!
    @IBOutlet private weak var labelTripType : UILabel!
    @IBOutlet private weak var imageViewBusiness : UIImageView!
    @IBOutlet private weak var imageViewPersonal : UIImageView!
    @IBOutlet private weak var viewBusiness : UIView!
    @IBOutlet private weak var viewPersonal : UIView!
    
    @IBOutlet var textFieldServiceType: HoshiTextField!
    @IBOutlet var textFieldCarModel: HoshiTextField!
    @IBOutlet var textFieldCarNumber: HoshiTextField!
    
    // MARK:- LocalVariable

    private var accountKit: AKFAccountKit?
    private var changedImage : UIImage?
    let profile = profilePostModel()
    var servicemodel = ServiceModel()
    var phoneNumber = String()
    var phoneCode = String()
    var data : Data?
    
    private lazy var loader : UIView = {
        
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

// MARK:- LocalMethod

extension ProfileViewController {
    
    private func initialLoads() {
        
        self.viewPersonal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewBusiness.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewImageChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeImage)))
        self.buttonSave.addTarget(self, action: #selector(self.buttonSaveAction), for: .touchUpInside)
        self.buttonChangePassword.isHidden = (User.main.login_by != LoginType.manual.rawValue)
        self.buttonChangePassword.addTarget(self, action: #selector(self.changePasswordAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.profile.localize()
        getProfile()
        self.localize()
        self.setDesign()
        self.view.dismissKeyBoardonTap()
        self.textFieldCarModel.isUserInteractionEnabled = false
        self.textFieldCarNumber.isUserInteractionEnabled = false
        self.textFieldServiceType.isUserInteractionEnabled = false
        print(LoginType.facebook)
        print(LoginType.google)
    }
    
    func getProfile(){
        self.presenter?.get(api: .getProfile, parameters: nil)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y<0 else { return }
        let inset = abs(scrollView.contentOffset.y/imageViewProfile.frame.height)
        self.imageViewProfile.transform = CGAffineTransform(scaleX: 1+inset, y: 1+inset)
        
    }
    
    private func setProfile(){
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(String(describing: User.main.picture ?? "0"))") { (image) in
            DispatchQueue.main.async {
                self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "young-male-avatar-image") : image
            }
        }
        
        self.textFieldFirst.text = User.main.firstName
        self.textFieldLast.text = User.main.lastName
        self.textFieldEmail.text = User.main.email
        self.textFieldServiceType.text = User.main.serviceType
        self.textFieldCarNumber.text = User.main.service_number
        self.textFieldCarModel.text = User.main.service_model
        self.textFieldPhone.text = "\(User.main.country_code ?? "")\(User.main.mobile ?? "")"
    }

    private func setDesign() {
        
        var attributes : [ NSAttributedString.Key : Any ] = [.font : UIFont(name: FontCustom.medium.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)]
        attributes.updateValue(UIColor.white, forKey: NSAttributedString.Key.foregroundColor)
        self.buttonSave.setAttributedTitle(NSAttributedString(string: Constants.string.save.localize().uppercased(), attributes: attributes), for: .normal)
        [textFieldFirst, textFieldLast, textFieldEmail, textFieldPhone, textFieldServiceType, textFieldCarNumber,textFieldCarModel].forEach({
            $0?.borderInactiveColor = nil
            $0?.borderActiveColor = nil
            Common.setFont(to: $0!)
        })
        
    }
    
    private func setLayout(){
        
        self.imageViewProfile.makeRoundedCorner()
    }
    
    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .secondary
        
    }
    
    private func localize() {
        
        self.textFieldFirst.placeholder = Constants.string.firsrName.localize()
        self.textFieldLast.placeholder = Constants.string.lastName.localize()
        self.textFieldPhone.placeholder = Constants.string.phoneNumber.localize()
        self.textFieldEmail.placeholder = Constants.string.email.localize()
        self.textFieldServiceType.placeholder = Constants.string.service.localize()
        self.textFieldCarNumber.placeholder = Constants.string.carNumber.localize()
        self.textFieldCarModel.placeholder = Constants.string.carModel.localize()
        self.buttonChangePassword.setTitle(Constants.string.lookingToChangePassword.localize(), for: .normal)
    }
}

// MARK:- IBAction

extension ProfileViewController {
    
    @IBAction private func editBtnAction(sender: UIButton) {
        self.accountKit = AKFAccountKit(responseType: .accessToken)
        let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: "")
        let accountKitVC = accountKit?.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
        accountKitVC!.enableSendToFacebook = true
        self.prepareLogin(viewcontroller: accountKitVC!)
        self.present(accountKitVC!, animated: true, completion: nil)
    }
    
    @objc private func changeImage() {
        
        self.showImage { (image) in
            if image != nil {
                self.imageViewProfile.image = image
                self.changedImage = image
            }
        }
    }
    
    @objc func setTripTypeAction(sender : UITapGestureRecognizer) {
        
        //        guard let senderView = sender.view else { return }
        //        self.tripType = senderView == viewPersonal ? .Personal : .Business
    }
    
    @IBAction func buttonSaveAction(){
        
        self.view.endEditingForce()
        
        guard let firstName = self.textFieldFirst.text, firstName.count>0 else {
            vibrate(sound: .cancelled)
            textFieldFirst.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterFirstName.localize())
            return
        }
        
        guard let lastName = self.textFieldLast.text, lastName.count>0 else {
            vibrate(sound: .cancelled)
            textFieldLast.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterLastName.localize())
            return
        }
        
        guard let mobile = self.textFieldPhone.text, mobile.count>0 else {
            vibrate(sound: .cancelled)
            textFieldPhone.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterPhoneNumber.localize())
            return
        }
        
        guard let email = self.textFieldEmail.text, email.count>0 else {
            vibrate(sound: .cancelled)
            textFieldEmail.shake()
            
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterEmail.localize())
            return
        }
        
        guard Common.isValid(email: email) else {
            vibrate(sound: .cancelled)
            textFieldEmail.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterValidEmail.localize())
            return
        }
        
        if self.changedImage != nil, let dataImg = self.changedImage!.pngData() {
            data = dataImg
        }
        
        if self.textFieldPhone.text != User.main.mobile {
            
            self.profile.mobile = self.textFieldPhone.text
            
            presenter?.post(api: .phoneNubVerify, data: profile.toData())
        }
        
        servicemodel.service = User.main.serviceId
        
        profile.device_token = deviceTokenString
        profile.email = email
        profile.first_name = firstName
        profile.last_name = lastName
        profile.mobile = phoneNumber
        profile.country_code = phoneCode
        profile.service = servicemodel.service
        profile.service_model = servicemodel.service_model
        self.loader.isHidden = false
        
        if data == nil {
            self.presenter?.post(api: .updateProfile, data: profile.toData())
        }
        else {
            var json = profile.JSONRepresentation
            json.removeValue(forKey: "id")
            json.removeValue(forKey: "picture")
            json.removeValue(forKey: "access_token")
            json.removeValue(forKey: "avatar")
            json.removeValue(forKey : "service")
            
            self.presenter?.post(api: .updateProfile, imageData: [WebConstants.string.picture : data!], parameters: json)
        }
    }
    
    @IBAction private func changePasswordAction() {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeResetPasswordController) as? ChangeResetPasswordController {
            vc.isChangePassword = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK:- UITextFieldDelegate

extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as! HoshiTextField).borderInactiveColor = UIColor.lightGray
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
    }
}

// MARK:- AKFViewControllerDelegate

extension ProfileViewController : AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        self.loader.isHidden = true
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print(state)
        accountKit?.requestAccount { (account, error) in
            self.phoneNumber = account?.phoneNumber?.stringRepresentation() ?? ""
            self.profile.mobile = self.phoneNumber
        }
        
        viewController.dismiss(animated: true) {
            AKFAccountKit(responseType: AKFResponseType.accessToken).requestAccount({ (account, error) in
                
                guard let number = account?.phoneNumber?.phoneNumber, let code = account?.phoneNumber?.countryCode, let numberInt = Int(code+number) else {
                    return
                }
                
                
                if let tempDialCode = account?.phoneNumber?.countryCode, let tempDialNumer = account?.phoneNumber?.phoneNumber {
                    self.phoneNumber = tempDialNumer
                    self.phoneCode = tempDialCode
                }
                
                print(numberInt)
                self.textFieldPhone.text = String(numberInt)
            })
        }
    }
}

// MARK:- PostviewProtocol

extension ProfileViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        if api == .phoneNubVerify {
            self.textFieldPhone.shake()
            DispatchQueue.main.async {
                self.textFieldPhone.resignFirstResponder()
            }
        }
        
        DispatchQueue.main.async {
            self.view.make(toast: message)
            self.loader.isHidden = true
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        if api == .updateProfile {
            toastSuccess(self.view, message: Constants.string.profileUpdatedSucess as NSString, smallFont: true, isPhoneX: true, color: .primary)
            let serviceType = User.main.serviceType
            let serviceId = User.main.serviceId
            Common.storeUserData(from: data)
            User.main.serviceType = serviceType
            User.main.serviceId = serviceId
            storeInUserDefaults()
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.setProfile()
            }
        }
        else {
            Common.storeUserData(from: data)
            storeInUserDefaults()
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.setProfile()
            }
            
        }
    }
}
