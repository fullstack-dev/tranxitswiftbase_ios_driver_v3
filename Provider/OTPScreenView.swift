//
//  VerificationController.swift
//  User
//
//  Created by CSS on 20/02/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class OTPScreenView: UIView {
    
    // MARK:- IBOutlet

    @IBOutlet var mainView: UIView!
    @IBOutlet private var textField1 : UITextView!
    @IBOutlet private var textField2 : UITextView!
    @IBOutlet private var textField3 : UITextView!
    @IBOutlet private var textField4 : UITextView!
    @IBOutlet private var textField5 : UITextView!
    @IBOutlet private var textField6 : UITextView!
    @IBOutlet var buttonDone: UIButton!
    
    // MARK:- LocalVariable

    private var countryCode : String = .Empty
    private var number : String = .Empty
    var userEnterdOtp : String = .Empty
    var completion : ((Bool)->())?
    var otp  = [String]()

    private lazy var textFieldsArray = [self.textField1,self.textField2,self.textField3,self.textField4]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    //Initial Loads
    private func initialLoads(){
        self.dismissKeyBoardonTap()
        self.otp.removeAll()
        textField1.becomeFirstResponder()
        textFieldsArray.forEach { (textField) in
            textField?.delegate = self
            textField?.addShadow(color: .lightGray, opacity: 1, offset: CGSize(width: 0.1, height: 0.1), radius: 10, rasterize: false, maskToBounds: true)
            
        }
    }
    
    //Set Country Code and number
    
    func set(number : String, with completion : @escaping (Bool)->()) {
        
        print("otp In OTPScreen>>> \(number)")
        self.number = number
        self.completion = completion
    }
    
    func toast(message: String){
        toastSuccess(UIApplication.shared.keyWindow! , message: Constants.string.wrongOTP as NSString, smallFont: true, isPhoneX: true, color: UIColor.red)
        vibrate(sound: .cancelled)
    }
    
    
    @IBAction private func confirmButtonClick(sender : UIButton){
        otp.removeAll()
        
        guard let otp1 = textField1.text, !otp1.isEmpty else {
            toast(message: ErrorMessage.list.enterOTP)
            
            return
        }
        
        guard let otp2 = textField2.text, !otp2.isEmpty else {
            toast(message: ErrorMessage.list.enterOTP)
            
            return
        }
        guard let otp3 = textField3.text, !otp3.isEmpty else {
            toast(message: ErrorMessage.list.enterOTP)
            
            return
        }
        
        guard let otp4 = textField4.text, !otp4.isEmpty else {
            toast(message: ErrorMessage.list.enterOTP)
            
            return
        }
        
        otp.append(textField1.text)
        otp.append(textField2.text)
        otp.append(textField3.text)
        otp.append(textField4.text)
        
        print(otp.joined())
        
        
        
        self.userEnterdOtp = otp.joined()
        let checkOtp = self.userEnterdOtp
        guard self.number == checkOtp else {
            toast(message: ErrorMessage.list.wrongOTP)
            return
        }
        self.completion?(true)
    }
    
    
    private func makeResponsive(textView : UITextView){
        
        textFieldsArray.forEach { (field) in
            
            field?.layer.masksToBounds = !(textView == field)
        }
    }
}


extension OTPScreenView : UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.makeResponsive(textView: textView)
        
        if textView.text.count>1, var text = textView.text {
            text.removeFirst()
            textView.text = text
        }
        
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if Int.val(val: textView.text?.count)>1, var text = textView.text {
            text.removeFirst()
            textView.text = text
        }
        
        if textView.text.count>=1 {
            
            switch textView {
                
            case textField1 :
                
                textField2.becomeFirstResponder()
                
            case textField2 :
                
                textField3.becomeFirstResponder()
            case textField3 :
                textField4.becomeFirstResponder()
            default :
                textView.resignFirstResponder()
                
            }
            
        }
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
        
        if Int.val(val: textField.text?.count)>1, var text = textField.text {
            text.removeFirst()
            textField.text = text
        }
        
    }
}





