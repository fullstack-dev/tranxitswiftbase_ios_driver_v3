//
//  ImageView.swift
//  User
//
//  Created by CSS on 09/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
@IBDesignable class ImageView: UIImageView {
    
    //MARK:- Make Rounded Corner
    @IBInspectable var isRoundedCorner : Bool = false {
        
        didSet {
            if isRoundedCorner {
                self.layer.masksToBounds = true
                self.layer.cornerRadius =  frame.height/2
            }
        }
    }
    
    //MARK:- Make Image Tint Color
    @IBInspectable var isImageTintColor : Bool = false {
        
        didSet {
            if isImageTintColor {
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
                
            }
        }
    }
}
