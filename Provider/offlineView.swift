//
//  offlineView.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import EFAutoScrollLabel

class offlineView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet var viewAutoScrollNotVerified: EFAutoScrollLabel!
    
    var scrollTextVerified = false {
        didSet {
            self.viewAutoScrollNotVerified.text = scrollTextVerified ? Constants.string.accountNotVerifiedYet.localize() : Constants.string.balanceAlert.localize()
        }
    }
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        setAutoScroll()
    }
    
    func setAutoScroll(){
        
        self.viewAutoScrollNotVerified.labelSpacing = UIScreen.main.bounds.width
        self.viewAutoScrollNotVerified.pauseInterval = 1.0
        self.viewAutoScrollNotVerified.scrollSpeed = 60
        self.viewAutoScrollNotVerified.textAlignment = NSTextAlignment.left
        self.viewAutoScrollNotVerified.fadeLength = 0
        self.viewAutoScrollNotVerified.scrollDirection = EFAutoScrollDirection.Left
        self.viewAutoScrollNotVerified.font = UIFont(name: FontCustom.bold.rawValue, size: 18)
        self.viewAutoScrollNotVerified.observeApplicationNotifications()
        self.viewAutoScrollNotVerified.isUserInteractionEnabled = false
        self.mainView.addSubview(self.viewAutoScrollNotVerified)
    }

}
