//
//  ForgotPasswordViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : HoshiTextField!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    
    //MARK:- LocalVariable
    
    var emailString : String?
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}

//MARK:- LocalMethods

extension ForgotPasswordViewController {
    
    private func initialLoads(){
        
        self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.setFrame()
        self.scrollView.addSubview(viewScroll)
        self.scrollView.isDirectionalLockEnabled = true
        self.textFieldEmail.text = emailString
    }
    
    private func setDesigns(){
        
        self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
        setFont(TextField: self.textFieldEmail, label: nil, Button: nil, size: 14)
    }
    
    private func setFrame() {
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
    }
    
    private func localize(){
        
        self.textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        self.navigationItem.title = Constants.string.enterYourMailIdForrecovery.localize()
    }
}

//MARK:- IBAction

extension ForgotPasswordViewController {
    
    @objc func nextAction(){
        
        self.viewNext.addPressAnimation()
        
        guard  let emailText = self.textFieldEmail.text, !emailText.isEmpty else {
            vibrate(sound: .cancelled)
            textFieldEmail.shake()
            self.view.make(toast: ErrorMessage.list.enterEmail) {
                self.textFieldEmail.becomeFirstResponder()
            }
            return
        }
        
        guard Common.isValid(email: emailText) else {
            vibrate(sound: .cancelled)
            textFieldEmail.shake()
            self.view.make(toast: ErrorMessage.list.enterValidEmail) {
                self.textFieldEmail.becomeFirstResponder()
            }
            return
        }
        
        var usersData = UserData()
        usersData.email = emailText
        self.loader.isHidden = false
        self.presenter?.post(api: .forgotPassword, data: usersData.toData())
    }
}

//MARK:- UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldEmail.placeholder = Constants.string.email.localize()
        
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        }
        
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
    }
    
}

//MARK:- PostViewProtocol

extension ForgotPasswordViewController: PostViewProtocol {
    
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.view.make(toast: message)
            self.loader.isHidden = true
        }
    }
    
    func getUserData(api: Base, data: ForgotResponse?) {
        
        if data != nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeResetPasswordController) as? ChangeResetPasswordController {
                vc.set(user: (data?.provider!)!)
                vc.isChangePassword = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        self.loader.isHideInMainThread(true)
    }
}

