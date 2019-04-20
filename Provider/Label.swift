//
//  Label.swift
//  User
//
//  Created by imac on 12/22/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

@IBDesignable class Label : UILabel {
    
    //MARK:- Button Text Color
    
    @IBInspectable var textColorId : Int = 0{
        
        didSet {
            
            self.textColor = {
                
                if let color = Color.valueFor(id: textColorId){
                    return color
                } else {
                    return textColor
                }
                
            }()
        }
        
    }
    
    //MARK:- UnderLined
    
    @IBInspectable var isUnderLined : Bool = false {
        
        didSet {
            updateAttributedText()
            
        }
    }
    
    //MARK:- Attributed String
    
    @IBInspectable var startLocation : Int = 0 {
        didSet{
            updateAttributedText()
        }
    }
    
    @IBInspectable var length : Int = 0 {
        didSet {
            updateAttributedText()
        }
    }
    
    @IBInspectable var attributeColor : UIColor = .black {
        didSet{
            updateAttributedText()
        }
    }
    
    private func updateAttributedText(){
        
        let mutableString = NSMutableAttributedString(string: String.removeNil(self.text), attributes: [NSAttributedString.Key.font: self.font ?? (UIFont(name: "Lato-Regular", size: 14.0))!])
        
        var attributes = [NSAttributedString.Key : Any]()
        
        if isUnderLined{
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .underlineStyle)
        }
        attributes.updateValue(attributeColor, forKey: .foregroundColor)
        mutableString.addAttributes(attributes, range: NSRange(location:startLocation,length:length))
        self.attributedText = mutableString
    }
    
}
