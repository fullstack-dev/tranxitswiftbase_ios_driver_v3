//
//  RideAcceptView.swift
//  User
//
//  Created by CSS on 03/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RideAcceptView: UIView {

    
    //MARK:- IBOutlet
    
    @IBOutlet var viewRequest: UIView!
    @IBOutlet var viewVisualEffect: UIVisualEffectView!
    @IBOutlet var pickUpLocation: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var labelPickUp: UILabel!
    @IBOutlet var labelDrop: UILabel!
    @IBOutlet var labelDropLocationValue: UILabel!
    @IBOutlet var viewRatings: HCSStarRatingView!
    @IBOutlet var RejectBtn: UIButton!
    @IBOutlet var AcceptBtn: UIButton!
    @IBOutlet private var labelScheduleTime : Label!
    @IBOutlet var UserProfile: UIImageView!
    @IBOutlet var labelTime : UILabel!
    
    //MARK:- LocalVariable

    var timer = Timer()
    var timeSecond = 60
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelTime.text = "\(timeSecond)"
        setRequestAnimation()
        setCommonFont()
        setRoundCorner()
        localization()
    }
    
    func setRequestAnimation(){
        
        let layer = setupCircleLayers(view: viewRequest)
        self.viewRequest.layer.insertSublayer(layer, below: labelTime.layer)
        self.viewRequest.bringSubviewToFront(self.labelTime)
    }
    
    func setCommonFont(){
        setFont(TextField: nil, label: userName, Button: RejectBtn, size: nil)
        setFont(TextField: nil, label: nil, Button: RejectBtn, size: nil)
        setFont(TextField: nil, label: pickUpLocation, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: AcceptBtn, size: nil)
        setFont(TextField: nil, label: labelPickUp, Button: nil, size: nil)
        setFont(TextField: nil, label: labelDrop, Button: nil, size: nil)
        setFont(TextField: nil, label: labelDropLocationValue, Button: nil, size: nil)
    }
    
    func localization(){
        self.labelDrop.text = Constants.string.dropLocation.localize()
        self.labelPickUp.text = Constants.string.pickUpLocation.localize()
        self.AcceptBtn.setTitle(Constants.string.accept.localize().uppercased(), for: .normal)
        self.RejectBtn.setTitle(Constants.string.reject.localize().uppercased(), for: .normal)
    }
    
    func setRoundCorner(){
        self.UserProfile.cornerRadius = self.UserProfile.frame.height/2
        self.UserProfile.clipsToBounds = true
    }
    
    func setSchedule(date : Date) {
        self.labelScheduleTime.text = "\(Constants.string.scheduledFor.localize()) \(Formatter.shared.getString(from: date, format: DateFormat.list.MMM_dd_yyyy_hh_mm_ss_a))"
        self.labelScheduleTime.attributeColor = .primary
        self.labelScheduleTime.startLocation = 0
        self.labelScheduleTime.length = Constants.string.scheduledFor.localize().count
    }
}
