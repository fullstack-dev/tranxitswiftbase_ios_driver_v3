//
//  Extension.swift
//  User
//
//  Created by CSS on 03/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import UIKit


enum Transition {
    
    case top
    case bottom
    case right
    case left
    
    var type : String {
        
        switch self {
            
        case .top :
            return kCATransitionFromBottom
        case .bottom :
            return kCATransitionFromTop
        case .right :
            return kCATransitionFromLeft
        case .left :
            return kCATransitionFromRight
            
        }
        
    }
    
}


extension UIView{
    func showAnimateView(_ view: UIView, isShow: Bool) {
        if isShow {
            view.isHidden = false
            self.bringSubview(toFront: view)
            pushTransition(0.8, view: view, withDirection: 3)
            
            
        }
        else {
            self.sendSubview(toBack: view)
            view.isHidden = true
            pushTransition(0.8, view: view, withDirection: 4)
        }
    }
    
    
    
    
    func pushTransition(_ duration: CFTimeInterval, view: UIView, withDirection direction: Int) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        
        if direction == 1 {
            animation.subtype = kCATransitionFromRight
        }
        else if direction == 2 {
            animation.subtype = kCATransitionFromLeft
        }
        else if direction == 3 {
            animation.subtype = kCATransitionFromTop
        }
        else {
            animation.subtype = kCATransitionFromBottom
        }
        
        animation.duration = duration
        view.layer.add(animation, forKey: kCATransitionMoveIn)
        
    }
    func show(with transition : Transition, duration : CFTimeInterval = 0.5, completion : (()->())?){
        
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = transition.type
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionPush)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    
}
