//
//  TollFeeView.swift
//  TranxitUser
//
//  Created by Ansar on 11/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

class TollFeeView : UIView {
    
    //MARK:- IBOutlet

    @IBOutlet weak var lblAppNameTitle:UILabel!
    @IBOutlet weak var lblCurrency:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var fieldTollFee:HoshiTextField!
    @IBOutlet weak var btnDismiss:UIButton!
    @IBOutlet weak var btnSubmit:UIButton!
    
    //MARK:- LocalVariable
    
    var onClickDismiss : ((String,Bool)->Void)? //both for submit and dismiss
    var keyboardShow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        localize()
        fieldTollFee.delegate = self
        self.btnDismiss.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        self.btnSubmit.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//MARK:- LocalMethod

extension TollFeeView {
    
    func setFont()  {
        Common.setFont(to: lblAppNameTitle)
        Common.setFont(to: lblTitle)
        Common.setFont(to: fieldTollFee)
        Common.setFont(to: btnDismiss)
        Common.setFont(to: btnSubmit)
        Common.setFont(to: lblCurrency)
        lblAppNameTitle.textColor = .primary
        lblTitle.textColor = .black
        btnDismiss.backgroundColor = .primary
        btnSubmit.backgroundColor = .secondary
    }
    
    func localize() {
        lblAppNameTitle.text = AppName
        lblTitle.text = Constants.string.addTollAmount.localize()
        btnDismiss.setTitle(Constants.string.dismiss.localize(), for: .normal)
        btnSubmit.setTitle(Constants.string.submit.localize(), for: .normal)
        lblCurrency.text = User.main.currency
        fieldTollFee.text = "0"
    }
    
    @objc func tapDismiss() {
        onClickDismiss!("",true)
    }
    
    @objc func tapSubmit() {
        if (fieldTollFee.text?.isEmpty)! || fieldTollFee.text == "0" {
            UIApplication.shared.keyWindow?.makeToast(Constants.string.tollErrorMsg, duration: 1.0, position: .center)
            return
        }
        onClickDismiss!(fieldTollFee.text!,false)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if !keyboardShow {
                keyboardShow = true
                self.frame.origin.y = (((UIApplication.shared.keyWindow?.frame.size.height)!/2+(self.frame.height/2))-keyboardHeight)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardShow = false
        self.frame.origin.y = (((UIApplication.shared.keyWindow?.frame.size.height)!/2)-(self.frame.height/2))
    }
    
}

//MARK:- UITextFieldDelegate

extension TollFeeView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            textField.text = "0"
        }
        return true
    }
}
