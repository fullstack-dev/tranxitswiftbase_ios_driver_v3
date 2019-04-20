//
//  LaunchViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Crashlytics

class LaunchViewController: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet private var buttonSignIn : UIButton!
    @IBOutlet private var buttonSignUp : UIButton!
    @IBOutlet private var buttonSocialLogin : UIButton!
    
    //MARK:- Varaiable
    
    var presenter: PostPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        checkUserAppExist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.buttonAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- Methods

extension LaunchViewController {
    
    // if driver app exist need to show warning alert
    func checkUserAppExist() {
        let app = UIApplication.shared
        let bundleId = driverBundleID+"://"
        
        if app.canOpenURL(URL(string: bundleId)!) {
            let appExistAlert = UIAlertController(title: "", message: Constants.string.warningMsg.localize(), preferredStyle: .actionSheet)
            
            appExistAlert.addAction(UIAlertAction(title: Constants.string.Continue.localize(), style: .default, handler: { (Void) in
                print("App is install")
            }))
            present(appExistAlert, animated: true, completion: nil)
        }
        else {
            print("App is not installed")
        }
    }
    
    private func initialLoads(){
        
        self.setLocalization()
        // self.setDesigns()
        setCommonFont()
    }
    
    //Set Font Family
    private func setDesigns(){
        
        buttonSignIn.titleLabel?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        buttonSignUp.titleLabel?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        buttonSignIn.setTitleColor(.white, for: .normal)
        buttonSignUp.setTitleColor(.white, for: .normal)
    }
    
    private func setCommonFont() {
        
        setFont(TextField: nil, label: nil, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonSignIn, size: nil, with : true)
        setFont(TextField: nil, label: nil, Button: buttonSignUp, size: nil, with : true)
        setFont(TextField: nil, label: nil, Button: buttonSocialLogin, size: nil, with : true)
        buttonSignIn.setTitleColor(.white, for: .normal)
        buttonSignUp.setTitleColor(.white, for: .normal)
    }
    
    private func buttonAction() {
        
        buttonSignIn.addTarget(self, action: #selector(signInBtnTapped(Sender:)), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(signUpBtnTapped(sender:)), for: .touchUpInside)
        buttonSocialLogin.addTarget(self, action: #selector(socialLoginbuttonTapped(button:)), for: .touchUpInside)
    }
    
    //Method Localize Strings
    private func setLocalization(){
        
        buttonSignUp.setTitle(Constants.string.signUp.localize(), for: .normal)
        buttonSignIn.setTitle(Constants.string.signIn.localize(), for: .normal)
        buttonSocialLogin.setTitle(Constants.string.orConnectWithSocial.localize(), for: .normal)
    }
}

//MARK:- IBAction

extension LaunchViewController {
    
    @objc private func socialLoginbuttonTapped(button: UIButton) {
        
        self.push(id: Storyboard.Ids.SocialLoginViewController, animation: true, from: Router.user)
    }
    
    @objc private func signInBtnTapped(Sender: UIButton) {
        
        push(id: Storyboard.Ids
            .EmailViewController, animation: true, from: Router.user)
    }
    
    @objc private func signUpBtnTapped(sender:UIButton) {
        
        push(id: Storyboard.Ids.SignUpViewController, animation: true, from: Router.user)
    }
    
    @objc private func socialBtnLogin(sender: UIButton) {
        
        push(id: Storyboard.Ids.SocialLoginViewController, animation: true, from: Router.user)
    }
}

//MARK:- PostViewProtocol

extension LaunchViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
    }
}

//MARK:- UIScrollViewDelegate

extension LaunchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


