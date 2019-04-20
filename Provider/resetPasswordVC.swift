//
//  resetPasswordVC.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class resetPasswordVC: UITableViewController {

    //MARK:- IBOutlet

    @IBOutlet var notes: UILabel!
    @IBOutlet var oldPasswordTExt: HoshiTextField!
    @IBOutlet var newPasswordText: HoshiTextField!
    @IBOutlet var emailTxt: HoshiTextField!
    @IBOutlet var OTPText: HoshiTextField!
    @IBOutlet var nextView: UIView!
    @IBOutlet var nextImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addGustureForNextView()
        SetNavigationcontroller()
        localize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCommonFont()
    }
}

//MARK:- LocalMethod

extension resetPasswordVC {
    
    private func setCommonFont(){
        
        setFont(TextField: oldPasswordTExt, label: notes, Button: nil
            , size: nil)
        setFont(TextField: newPasswordText, label: nil, Button: nil, size: nil)
        setFont(TextField: emailTxt, label: nil, Button: nil
            , size: nil)
        setFont(TextField: OTPText, label: nil, Button: nil, size: nil)
    }
    
    
    private func localize(){
        self.notes.text = Constants.string.notes.localize()
        self.emailTxt.placeholder = Constants.string.emailPlaceHolder.localize()
        self.OTPText.placeholder = Constants.string.enterOTP.localize()
        self.newPasswordText.placeholder = Constants.string.enterNewPwd.localize()
        self.oldPasswordTExt.placeholder = Constants.string.oldPassword.localize()
    }
    
    private func SetNavigationcontroller(){
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = Constants.string.resetPassword.localize()
    }
    
    private func addGustureForNextView(){
        let nextGusture = UITapGestureRecognizer(target: self, action: #selector(nextBtnTapped(sender:)))
        self.nextView.addGestureRecognizer(nextGusture)
        
    }
}


//MARK:- IBAction

extension resetPasswordVC {
    
    @objc func nextBtnTapped(sender: UITapGestureRecognizer){
    
        guard let email = emailTxt.text, !email.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterEmail)
            return
        }
        
        guard Common.isValid(email: email) else {
            self.view.make(toast: ErrorMessage.list.enterValidEmail) {
                self.emailTxt.becomeFirstResponder()
            }
            
            return
            
        }

        guard let OTP = OTPText.text, !OTP.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterOTP)
            return
        }
        
        guard let newPassword = newPasswordText.text, !newPassword.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterNewPwd)
            return
        }
        
        guard let oldPassword = oldPasswordTExt.text, !oldPassword.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterOldPassword)
            return
        }
    }
}


//MARK:- UITextFieldDelegate

extension resetPasswordVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as! HoshiTextField).borderInactiveColor = UIColor.lightGray
    }
}

//MARK:- PostViewProtocol

extension resetPasswordVC : PostViewProtocol {
    func getResetpassword(api: Base, data: resetPasswordModel?) {
       // print("resetpasssword sucess: \(data)")
    }
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
}
