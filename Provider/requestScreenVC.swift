//
//  requestScreenVC.swift
//  User
//
//  Created by CSS on 10/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class requestScreenVC: UIViewController {
    
    //MARK:- IBOutlet

    @IBOutlet var viewRequestScreen: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            setupAnimationGroup()
        }
    }
}

//MARK:- Method

extension requestScreenVC {
    
    private func addCircleAnimation () {
        
        //setCircleAnimation(view: self.viewRequestScreen)
    }
    
    private func addPluseAnimation() {
        let pulse = Pulsing(numberOfPulses: .infinity, radius: 200, position: self.viewRequestScreen.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.blue.cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }
    
    func addBlurEffect() {
        
        addBlurEffectToView(view: self.viewRequestScreen, blurEffect: .regular, backGroundColor: .clear)
    }
    
}
