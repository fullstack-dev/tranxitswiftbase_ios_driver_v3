//
//  AddCardViewController.swift
//  User
//
//  Created by CSS on 23/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import CreditCardForm
import Stripe

class AddCardViewController: UIViewController {
    
    @IBOutlet private weak var creditCardView : CreditCardFormView!
    var paymentTextField = STPPaymentCardTextField()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    var isGettingDocuments = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AddCardViewController {
    
    func initialLoads() {
        
        self.creditCardView.cardHolderString = String.removeNil(User.main.firstName)+" "+String.removeNil(User.main.lastName)
        self.creditCardView.defaultCardColor = .primary
        self.createTextField()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:  #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backBarButtonAction))
        
        self.navigationItem.title = Constants.string.card.localize()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.Done.localize(), style: .done, target: self, action: #selector(self.doneButtonClick))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.view.dismissKeyBoardonTap()
    }
    
    // MARK:- Back Button Action
    
    @IBAction private func backBarButtonAction() {
        if isGettingDocuments {
            self.logout()
        } else {
            self.popOrDismiss(animation: true)
        }
    }
    
    // MARK:- Logout Action
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.logoutMessage.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            self.loader.isHidden = true
            self.presenter?.post(api: .logout, data: nil)
        }
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.view.tintColor = .primary
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    // MARK:- Done Button Click
    
    @IBAction private func doneButtonClick() {
        self.view.endEditingForce()
        self.loader.isHidden = false
        paymentTextField.cardParams.currency = "usd"
       
        STPAPIClient.shared().createToken(withCard: paymentTextField.cardParams) { (stpToken, error) in
            
            var token = String()
            if stpToken?.tokenId != nil {
                token = (stpToken?.tokenId)!
            }
            else {
                self.loader.isHideInMainThread(true)
            }
            
            if stpToken?.card?.funding.rawValue == 0 {
                
                var cardEntity = CardEntity()
                cardEntity.stripe_token = token
                self.presenter?.post(api: .postCards, data: cardEntity.toData())
            } else {
                self.loader.isHideInMainThread(true)
                showAlert(message: Constants.string.debitErrormsg.localize(), okHandler: nil, fromView: self)
                //  UIApplication.shared.keyWindow?.make(toast: Constants.string.PleaseAddOnlyDebitcard.localize())
                
            }
        }
    }
}

// MARK:- STPPaymentCardTextFieldDelegate

extension AddCardViewController : STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = textField.isValid
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
}

// MARK:- PostViewProtocol

extension AddCardViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getAddCardSuccess(api: Base, data: String?) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            let alert = showAlert(message: data) { (_) in
                if self.isGettingDocuments {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getSucessMessage(api: Base, data: String?) {
        
        if api == .logout {
            forceLogout(with: data)
            return
        }
        
    }
    
}
