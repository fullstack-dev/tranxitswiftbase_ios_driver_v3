//
//  SignUpTableViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit
import DropDown

class SignUpTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var EmailTxt: HoshiTextField!
    @IBOutlet var lastNametext: HoshiTextField!
    @IBOutlet weak var FirstName: HoshiTextField!
    @IBOutlet weak var Emailtext: HoshiTextField!
    @IBOutlet var textFieldPhoneNumber: HoshiTextField!
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet weak var fieldConfirmPassword: HoshiTextField!
    @IBOutlet var textFieldServiceType: HoshiTextField!
    @IBOutlet var textFieldVehicleNumber: HoshiTextField!
    @IBOutlet var textFieldModel: HoshiTextField!
    @IBOutlet var textFieldReferCode: HoshiTextField!
    @IBOutlet var viewReferCode: UIView!
    @IBOutlet var nextImage: UIImageView!
    @IBOutlet var nextView: UIView!
    @IBOutlet var textFieldCollection: [HoshiTextField]!
    @IBOutlet var vehiclePhotoView: UIView!
    @IBOutlet var countryText: HoshiTextField!
    @IBOutlet weak var countryImageView: UIImageView!
    
    //MARK:- Variable
    
    let serviceTypeView = DropDown()
    var serviceTypeArr : [serviceTypes]?
    private var countryCode : String?
    var selectedServiceID = 0
    var isReferalEnable = 0
    var phoneNumber = String()
    let accountKit = AKFAccountKit(responseType: .accessToken)
    private var userSignUpInfo : UserData?
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeNextButtonFrame()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        textFieldCollection.append(fieldConfirmPassword)
        self.SetNavigationcontroller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nextImage.isHidden = false
        
        //self.SetNavigationcontroller()
        self.unsetSelection()
        
        self.localization()
        
        self.addGustureforNextBtn()
        setCommonFont()
        //self.perform(#selector(self.addGustureForNextIcon), with: self, afterDelay: 2)
        self.presenter?.get(api: .settings, parameters: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextView.makeRoundedCorner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.nextView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.nextView.isHidden = false
    }
    
    deinit {
        self.nextView.removeFromSuperview()
    }
    
}

//MARK:- Method

extension SignUpTableViewController {
    
    private func localization(){
        EmailTxt.placeholder = Constants.string.email.localize()
        FirstName.placeholder = Constants.string.firsrName.localize()
        lastNametext.placeholder = Constants.string.lastName.localize()
        navigationItem.title = Constants.string.signUpNavTitle.localize()
        self.textFieldPassword.placeholder = Constants.string.password.localize()
        self.textFieldPhoneNumber.placeholder = Constants.string.phoneNumber.localize()
        self.fieldConfirmPassword.placeholder = Constants.string.ConfirmPassword.localize()
        self.textFieldModel.placeholder = Constants.string.carModel.localize()
        self.textFieldReferCode.placeholder = Constants.string.referalCode.localize()
        self.textFieldVehicleNumber.placeholder = Constants.string.carNumber.localize()
        self.textFieldServiceType.placeholder = Constants.string.serviceType.localize()
        self.countryText.placeholder = Constants.string.country.localize()
        
        if selectedLanguage == .arabic {
            self.countryText.textAlignment = .left
        }
        else{
            self.countryText.textAlignment = .right
        }
    }
    
    private func addGustureforNextBtn(){
        
        let nextBtnGusture = UITapGestureRecognizer(target: self, action: #selector(nextIconTapped(sender:)))
        self.nextView.addGestureRecognizer(nextBtnGusture)
    }
    
    
    private func setCommonFont(){
        
        for i in 0 ... textFieldCollection.count-1 {
            //            textFieldCollection[i].borderActiveColor = .primary
            //            textFieldCollection[i].borderInactiveColor = UIColor.lightGray
            //            textFieldCollection[i].placeholderColor = UIColor.gray
            textFieldCollection[i].textColor = UIColor.black
            textFieldCollection[i].delegate = self
            textFieldCollection[i].textAlignment = .left
            if textFieldCollection[i] == fieldConfirmPassword {
                print("Confirm password")
            }
            setFont(TextField: textFieldCollection[i], label: nil, Button: nil, size: nil)
        }
        
        textFieldPhoneNumber.delegate = self
        textFieldPassword.delegate = self
    }
    
    func unsetSelection() {
        
        self.tableView.allowsSelection = false
    }
    
    private func validateEmail()->String? {
        
        guard let email = EmailTxt.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterEmail.localize())
            EmailTxt.becomeFirstResponder()
            return nil
        }
        guard Common.isValid(email: email) else {
            self.showToast(string: ErrorMessage.list.enterValidEmail.localize())
            EmailTxt.becomeFirstResponder()
            return nil
        }
        return email
    }
    
    func showToast(string:String) {
        self.view.makeToast(string, duration: 1.0, position: .top)
    }
}

//MARK:- IBAction

extension SignUpTableViewController {
    
    @objc private func nextIconTapped(sender: UITapGestureRecognizer){
        
        guard let email = self.EmailTxt.text, !email.isEmpty else {
            vibrate(sound: .cancelled)
            self.EmailTxt.shake()
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterEmail.localize())
            return
        }
        
        guard Common.isValid(email: email) else {
            self.view.make(toast: ErrorMessage.list.enterValidEmail.localize()) {
                vibrate(sound: .cancelled)
                self.EmailTxt.shake()
                UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterEmail.localize())
                self.EmailTxt.becomeFirstResponder()
            }
            return
        }
        
        guard let firstName = self.FirstName.text, !firstName.isEmpty else {
            vibrate(sound: .cancelled)
            FirstName.shake()
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterFirstName.localize())
            return
        }
        
        guard let lastName = self.lastNametext.text, !lastName.isEmpty else {
            vibrate(sound: .cancelled)
            lastNametext.shake()
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterLastName.localize())
            return
        }
        
        guard let phoneNumber = self.textFieldPhoneNumber.text, !phoneNumber.isEmpty else {
            vibrate(sound: .cancelled)
            textFieldPhoneNumber.shake()
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.enterPhoneNumber.localize())
            return
        }
        
        guard let password = self.textFieldPassword.text, !password.isEmpty, password.count>=6 else {
            vibrate(sound: .cancelled)
            textFieldPassword.shake()
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.enterPassword.localize())
            return
        }
        
        guard let confirmPassword = self.fieldConfirmPassword.text, !confirmPassword.isEmpty, confirmPassword.count>=6 else {
            vibrate(sound: .cancelled)
            fieldConfirmPassword.shake()
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.enterConfirmPassword.localize())
            return
        }
        
        guard let serviceType = self.textFieldServiceType.text, !serviceType.isEmpty else {
            vibrate(sound: .cancelled)
            textFieldServiceType.shake()
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.enterServiceType.localize())
            return
        }
        
        guard let vehicleNumber = self.textFieldVehicleNumber.text, !vehicleNumber.isEmpty else {
            vibrate(sound: .cancelled)
            textFieldVehicleNumber.shake()
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.enterVehicleCode.localize())
            return
        }
        
        guard let vehicleModel = self.textFieldModel.text, !vehicleModel.isEmpty else {
            vibrate(sound: .cancelled)
            textFieldModel.shake()
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.enterModel.localize())
            return
        }
        
        if textFieldPassword.text != fieldConfirmPassword.text {
            UIApplication.shared.keyWindow?.make(toast: ErrorMessage.list.passwordNotMatch.localize())
            return
        }
        
        let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: phoneNumber)
        let accountKitVC = accountKit.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
        accountKitVC.enableSendToFacebook = true
        self.prepareLogin(viewcontroller: accountKitVC)
        self.present(accountKitVC, animated: true, completion: nil)
        
        userSignUpInfo = MakeJson.SingUp(firstName: firstName, lastName: lastName, email: email, mobile: Int(phoneNumber) ?? 0, password: password, ConfirmPassword: password, device_Id: deviceId, device_type: DeviceType.ios.rawValue, device_token: deviceTokenString, referral_code: isReferalEnable == 0 ? "" : self.textFieldReferCode.text!, service_type: String(selectedServiceID), service_number: vehicleNumber, service_model: self.textFieldModel.text!, country_code: self.countryText.text! )
    }
    
    private func changeNextButtonFrame() {
        
        UIApplication.shared.keyWindow?.addSubview(self.nextView)
        let frameWidth : CGFloat = 50 * (UIScreen.main.bounds.width/375)
        self.nextView.translatesAutoresizingMaskIntoConstraints = false
        self.nextView.heightAnchor.constraint(equalToConstant: frameWidth).isActive = true
        self.nextView.widthAnchor.constraint(equalToConstant: frameWidth).isActive = true
        self.nextView.bottomAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.bottomAnchor, constant: -16).isActive = true
        self.nextView.trailingAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.trailingAnchor, constant: -16).isActive = true
    }
    
    func SetNavigationcontroller(){
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
        else {
            //Fallback on earlier versions
        }
        title = "Enter the details you used to register"
        
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(SignUpTableViewController.backBarButton(sender:)))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(nextIconTapped(sender:)))
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            
            let country = Common.getCountries()
            for eachCountry in country {
                if countryCode == eachCountry.code {
                    print(eachCountry.dial_code)
                    countryText.text = eachCountry.dial_code
                    let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                    countryImageView.image = myImage
                }
            }
        }
    }
    
    @objc private func backBarButton(sender: UIButton){
        
        self.popOrDismiss(animation: true)
    }
}


//MARK:- UITextFieldDelegate

extension SignUpTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldServiceType {
            serviceTypeView.anchorView = textField
            var dataSource:[String]=[]
            for service in self.serviceTypeArr! {
                dataSource.append(service.name!)
            }
            serviceTypeView.dataSource = dataSource
            serviceTypeView.selectionAction = { [weak self] (index, item) in
                self?.textFieldServiceType.text = item
                self?.selectedServiceID = (self?.serviceTypeArr![index].id)!
            }
            DropDown.setupDefaultAppearance()
            serviceTypeView.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            serviceTypeView.show()
            return false
        }
        
        if textField == countryText {
            let coutryListvc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.CountryListController) as! CountryListController
            coutryListvc.FromSignUpPage = true
            self.present(coutryListvc, animated: true, completion: nil)
            coutryListvc.searchCountryCode = { code in
                print(code)
                self.countryCode = code
                let country = Common.getCountries()
                for eachCountry in country {
                    if code == eachCountry.code {
                        print(eachCountry.dial_code)
                        self.countryText.text = eachCountry.dial_code
                        let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                        self.countryImageView.image = myImage
                    }
                }
            }
            
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        EmailTxt.placeholder = Constants.string.email.localize()
        FirstName.placeholder = Constants.string.firsrName.localize()
        lastNametext.placeholder = Constants.string.lastName.localize()
        (textField as? HoshiTextField)?.borderActiveColor = UIColor.primary
    }
    
    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .secondary
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            EmailTxt.placeholder = Constants.string.email.localize()
            FirstName.placeholder = Constants.string.firsrName.localize()
            lastNametext.placeholder = Constants.string.lastName.localize()
        }
        (textField as? HoshiTextField)?.borderInactiveColor = UIColor.lightGray
        
        if textField == EmailTxt {
            if textField.text?.count == 0 {
                textField.placeholder = Constants.string.emailPlaceHolder.localize()
            } else if let email = validateEmail(){
                textField.resignFirstResponder()
                let user = User()
                user.email = email
                presenter?.post(api: .providerVerify, data: user.toData())
            }
        }
        
        if textField == textFieldPhoneNumber {
            if textFieldPhoneNumber.text != "" {
                let user = User()
                let nub = textFieldPhoneNumber.text!
                user.mobile = nub
                user.country_code = countryText.text!
                presenter?.post(api: .phoneNubVerify, data: user.toData())
            }
        }
    }
}

//MARK:- AKFViewControllerDelegate

extension SignUpTableViewController: AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        func dismiss () {
            viewController.dismiss(animated: true)
            self.loader.isHidden = false
            self.presenter?.post(api: .signUp, data: self.userSignUpInfo?.toData())
        }
        
        accountKit.requestAccount { (account, error) in
            self.phoneNumber = account?.phoneNumber?.phoneNumber ?? ""
            self.userSignUpInfo?.mobile = self.phoneNumber
            dismiss()
        }
    }
}

//MARK:- PostViewProtocol

extension SignUpTableViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        if api == .providerVerify {
            self.EmailTxt.shake()
            vibrate(sound: .tryAgain)
            DispatchQueue.main.async {
                self.EmailTxt.becomeFirstResponder()
            }
        }
        
        if api == .phoneNubVerify {
            self.textFieldPhoneNumber.shake()
            vibrate(sound: .tryAgain)
            DispatchQueue.main.async {
                self.textFieldPhoneNumber.becomeFirstResponder()
            }
        }
        
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
    }
    
    func getAuth(api: Base, data: UserData?) {
        
        if data?.access_token != nil{
            User.main.accessToken = data?.access_token
            storeInUserDefaults()
            self.presenter?.get(api: .getProfile, parameters: nil)
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        
        Common.storeUserData(from: data)
        storeInUserDefaults()
        DispatchQueue.main.async {
            self.loader.isHidden = true
            toastSuccess(UIApplication.shared.keyWindow! , message: Constants.string.signUpSucess as NSString, smallFont: true, isPhoneX: true, color: UIColor.primary)
            self.present(Common.setDrawerController(), animated: true, completion: nil)
        }
        
    }
    
    func getSettings(api: Base, data: SettingsEntity) {
        self.serviceTypeArr = data.serviceTypes
        self.viewReferCode.isHidden = data.referral?.referral == "0"
        self.isReferalEnable = Int((data.referral?.referral)!)!
    }
}

