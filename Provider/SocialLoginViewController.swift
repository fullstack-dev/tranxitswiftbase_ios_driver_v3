//
//  SocailLoginViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import AccountKit

class SocialLoginViewController: UITableViewController {
    
    //MARK:- LocalVariable

    private let tableCellId = "SocialLoginCell"
    private var userId : String?
    private var idToken : String?
    private var firstName : String?
    private var givenName : String?
    private var email : String?
    private var accessToken : String?
    private var faceBookAccessToken : String?
    private var phoneNumber : String?
    private var isfaceBook = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.initialLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
    }
}

// MARK:- LocalMethod

extension SocialLoginViewController {
    
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = false
        
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func localize() {
        
        self.navigationItem.title = Constants.string.chooseAnAccount.localize()
    }

    private func didSelect(at indexPath : IndexPath) {
        
        switch (indexPath.section,indexPath.row) {
       
        case (0,0):
            self.facebookLogin()
        case (0,1):
            self.googleLogin()
        default:
            break
        }
    }

    private func googleLogin(){
        self.isfaceBook = false
        print("Google")
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }

    private func facebookLogin() {
        self.isfaceBook = true
        print("Facebook")
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
                break
            case .cancelled:
                print("Cancelled")
                break
            case .success( _ ,  _, let accessToken):
                print(accessToken)
                self.faceBookAccessToken = accessToken.authenticationToken
                self.accountKit()
                break
            }
        }
    }
    
    private func loadAPI(accessToken: String?,PhoneNumber: String?, loginBy: LoginType?, country_code: String?){
        
        var faceBookModel = FacebookLoginModel()
        faceBookModel.accessToken = accessToken
        faceBookModel.device_id = UUID().uuidString
        faceBookModel.device_token = deviceTokenString
        faceBookModel.device_type = DeviceType.ios.rawValue
        faceBookModel.login_by = loginBy?.rawValue
        faceBookModel.mobile = Int(phoneNumber ?? "0")
        faceBookModel.country_code = "+\(country_code!)"
        
        if isfaceBook  {
            self.presenter?.post(api: .faceBookLogin, data: faceBookModel.toData())
        }else{
            self.presenter?.post(api: .googleLogin , data: faceBookModel.toData())
        }
    }
}

// MARK:- TableViewView

extension SocialLoginViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? SocialLoginCell {

            tableCell.labelTitle.text = (indexPath.row == 0 ? Constants.string.facebook : Constants.string.google).localize()
            tableCell.imageViewTitle.image = indexPath.row == 0 ? #imageLiteral(resourceName: "fb_icon") : #imageLiteral(resourceName: "google_icon")
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.didSelect(at: indexPath)
         tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- GIDSignInDelegate

extension SocialLoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("google error: \(error.localizedDescription)")
        } else {
            self.userId = user.userID                  // For client-side use only!
            self.idToken = user.authentication.accessToken // Safe to send to the server
            self.firstName = user.profile.name
            self.givenName = user.profile.givenName
            self.email = user.profile.email
            
            accountKit()
        }
    }
    
    private func accountKit(){
        let accountKit = AKFAccountKit(responseType: .accessToken)
        let accountKitVC = accountKit.viewControllerForPhoneLogin()
        accountKitVC.enableSendToFacebook = true
        self.prepareLogin(viewcontroller: accountKitVC)
        self.present(accountKitVC, animated: true, completion: nil)
    }
    
    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .secondary
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK:- GIDSignInUIDelegate

extension SocialLoginViewController: GIDSignInUIDelegate {
    
}

// MARK:- AKFViewControllerDelegate

extension SocialLoginViewController : AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print(state)
        viewController.dismiss(animated: true) {
            //self.loader.isHidden = false
            //self.presenter?.post(api: .signUp, data: self.userSignUpInfo?.toData())
           
            AKFAccountKit(responseType: AKFResponseType.accessToken).requestAccount({ (account, error) in
                print(account?.phoneNumber?.stringRepresentation() as Any)
                
                self.phoneNumber = account?.phoneNumber?.phoneNumber
                let code = account?.phoneNumber?.countryCode
              
                if self.isfaceBook {
                    self.loadAPI(accessToken: self.faceBookAccessToken, PhoneNumber: self.phoneNumber, loginBy: LoginType(rawValue: LoginType.facebook.rawValue), country_code: code)
                }else {

                    self.loadAPI(accessToken: self.idToken, PhoneNumber: self.phoneNumber, loginBy: LoginType(rawValue: LoginType.google.rawValue), country_code: code)
                }
              
            })

            
            print("google ACCOUNTID:\(String(describing: self.userId))")
        }
        
    }
}

// MARK:- PostViewProtocol

extension SocialLoginViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
       
        DispatchQueue.main.async {
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getFaceBookAPI(api: Base, data: FacebookLoginModelResponse?) {
        
      
        if data != nil {
            print(data?.name as Any)
            print("login sucess: \(String(describing: data?.access_token))")
            UserDefaults.standard.set(data?.access_token, forKey: "access_token")
            User.main.accessToken = data?.access_token
            
            storeInUserDefaults()
            
            if data?.access_token !=  nil {

                self.presenter?.get(api: .getProfile, parameters: nil)
            }
            else {
                
            }

        }else {
            print("data is empty")
        }
    }
    
    func getProfile(api: Base, data: Profile?) {

        Common.storeUserData(from: data)
        storeInUserDefaults()
        DispatchQueue.main.async {
            toastSuccess(UIApplication.shared.keyWindow! , message: Constants.string.loginSucess as NSString, smallFont: true, isPhoneX: true, color: UIColor.primary)
            self.present(Common.setDrawerController(), animated: true, completion: nil)

        }
    }
}

// MARK:- UITableViewCell

class SocialLoginCell : UITableViewCell {
    
    @IBOutlet weak var imageViewTitle : UIImageView!
    @IBOutlet weak var labelTitle : UILabel!
    
    override func awakeFromNib() {
        setCommonFont()
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: labelTitle, Button: nil, size: nil)
        
    }
    
}

