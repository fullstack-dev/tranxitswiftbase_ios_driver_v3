//
//  rideArrivedView.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import HCSStarRatingView
class rideArrivedView: UIView {
    
    
    //MARK:- IBOutlet
    
    @IBOutlet var btnWaitingTime: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var arrivedBtn: UIButton!

    //view outlets
    @IBOutlet var ratingView: HCSStarRatingView!
    @IBOutlet var viewVisualEffect: UIView!
    @IBOutlet var viewVisualEffectMain: UIVisualEffectView!
    @IBOutlet var viewCall: UIView!
    @IBOutlet var viewMessage: UIView!
    @IBOutlet var viewSeperator: UIView!
    
    //label outlets
    @IBOutlet var userName: UILabel!
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var lablelPickup: UILabel!
    @IBOutlet var labelDestination: UILabel!
    @IBOutlet var labelWaitingTimer: UILabel!
    @IBOutlet var labelDropValue: UILabel!
    @IBOutlet var labelDrop: UILabel!
    
    //image outlets
    @IBOutlet var imageArrived: UIImageView!
    @IBOutlet var imageFinished: UIImageView!
    @IBOutlet var imagePickup: UIImageView!
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var userProfile: UIImageView!
    
    //progressBar outlets:
    @IBOutlet var progressBarArrivedToPickUp: UIProgressView!
    @IBOutlet var progressBarPickupToFinished: UIProgressView!
    
    // An empty implementation adversely affects performance during animation.
    var hideWaitingTime : Bool = false {
        didSet {
            self.btnWaitingTime.isHidden = hideWaitingTime
            self.viewSeperator.isHidden = hideWaitingTime
            self.labelWaitingTimer.isHidden = hideWaitingTime
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.setCommonFont()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundCorner()
    }
    
    private func localize() {
        self.arrivedBtn.setTitle(Constants.string.arrived.localize().uppercased(), for: .normal)
        self.cancelBtn.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
        self.btnWaitingTime.setTitle(Constants.string.waitingTime.localize(), for: .normal)
    }
    
    
    func setCommonFont(){
        setFont(TextField: nil, label: userName, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: cancelBtn, size: nil)
        setFont(TextField: nil, label: nil, Button: arrivedBtn, size: nil)
        setFont(TextField: nil, label: lablelPickup, Button: nil, size: 12)
        setFont(TextField: nil, label: labelDropValue, Button: nil, size: 10)
        setFont(TextField: nil, label: labelDrop, Button: nil
            , size: 12)
        setFont(TextField: nil, label: nil, Button: self.btnWaitingTime, size: nil)
        setFont(TextField: nil, label: labelAddress, Button: nil, size: 10)
    }
    
    func setRoundCorner(){
        self.userProfile.cornerRadius = self.userProfile.frame.height / 2
        self.userProfile.clipsToBounds = true
        self.btnWaitingTime.cornerRadius = self.btnWaitingTime.frame.height/2
        self.btnWaitingTime.backgroundColor = UIColor.lightGray
    }
}
