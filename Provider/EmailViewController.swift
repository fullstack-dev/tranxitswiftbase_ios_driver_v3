//
//  EmailViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlet

    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : HoshiTextField!
    @IBOutlet private var buttonCreateAcount : UIButton!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    
    //MARK:- LocalVaraiable

    var isHideLeftBarButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
    }
    
}

//MARK:- LocalMethod

extension EmailViewController {
    
    private func initialLoads(){
        
        self.setCommonFont()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.navigationController?.isNavigationBarHidden = false
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        if !isHideLeftBarButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        }
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.scrollView.addSubview(viewScroll)
        self.buttonCreateAcount.addTarget(self, action: #selector(self.createAccountAction), for: .touchUpInside)
    }
    
    func SetNavigationcontroller(){
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = "Enter the details"
    }
    
    private func setDesigns(){
        
        self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
    }
    
    private func setCommonFont(){
        
        setFont(TextField: textFieldEmail, label: nil, Button: buttonCreateAcount, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonCreateAcount, size: nil)
    }
    
    private func localize() {
        self.textFieldEmail.placeholder = Constants.string.email.localize()
        let attr :[NSAttributedString.Key : Any]  = [.font : UIFont(name: FontCustom.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)]
        self.buttonCreateAcount.setAttributedTitle(NSAttributedString(string: Constants.string.iNeedTocreateAnAccount.localize(), attributes: attr), for: .normal)
        self.navigationItem.title = Constants.string.whatsYourEmailAddress.localize()
    }
}

//MARK:- IBAction

extension EmailViewController {
    
    @objc private func nextAction() {
        
        self.viewNext.addPressAnimation()
        
        guard  let emailText = self.textFieldEmail.text, !emailText.isEmpty else {
            vibrate(sound: .cancelled)
            self.textFieldEmail.shake()
            self.view.make(toast: ErrorMessage.list.enterEmail, duration: 0.5) {
                self.textFieldEmail.becomeFirstResponder()
            }
            return
        }
        
        guard Common.isValid(email: emailText) else {
            vibrate(sound: .cancelled)
            self.textFieldEmail.shake()
            
            self.view.make(toast: ErrorMessage.list.enterValidEmail, duration: 0.5) {
                self.textFieldEmail.becomeFirstResponder()
            }
            
            return
            
        }
        
        if let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PasswordViewController) as? PasswordViewController {
            
            passwordVC.set(email: emailText)
            self.navigationController?.pushViewController(passwordVC, animated: true)
            
        }
    }
    
    @objc func createAccountAction(){
        
        self.push(id: Storyboard.Ids.SignUpViewController, animation: true, from: Router.user)
    }
}

//MARK:- UITextFieldDelegate

extension EmailViewController : UITextFieldDelegate {
    
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
        (textField as! HoshiTextField).borderInactiveColor = UIColor.lightGray
    }
    
}


