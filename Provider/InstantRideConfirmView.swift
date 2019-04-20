//
//  InstantRideConfirmView.swift
//  Provider
//
//  Created by Sravani on 09/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class InstantRideConfirmView: UIView {

    //MARK:- IBOutlet

    @IBOutlet weak var confirmTitleLabel: UILabel!
    @IBOutlet weak var pickUpLocationTitleLbl: UILabel!
    @IBOutlet weak var PickUpAddressLbl: UILabel!
    @IBOutlet weak var pickUpImage: UIImageView!
   
    @IBOutlet weak var dropLocationTitleLbl: UILabel!
    @IBOutlet weak var dropLocationAddressLbl: UILabel!
    @IBOutlet weak var dropLocationImg: UIImageView!
    
    @IBOutlet weak var PhoneNumberTitle: UILabel!
    @IBOutlet weak var PhoneNumberLbl: UILabel!
    @IBOutlet weak var PhoneImage: UIImageView!
    
    @IBOutlet weak var estimatedTitle: UILabel!
    @IBOutlet weak var estimatedPriceLbl: UILabel!
    @IBOutlet weak var estimatedImg: UIImageView!
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
   
    //MARK:- LocalVariable

    var d_lat: Double?
    var d_lang: Double?
    var country_code: String?
    var mobile: String?
    
    var onClickConfirm : ((Bool)->Void)?
    var backGroundInstanse = BackGroundTask.backGroundInstance
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        localize()
    }
    
    private func localize() {
        
        self.confirmTitleLabel.text = Constants.string.pickUpLocationTitle.localize()
        self.pickUpLocationTitleLbl.text = Constants.string.pickUpLocation.localize()
        self.dropLocationTitleLbl.text = Constants.string.dropLocation.localize()
        self.PhoneNumberTitle.text = Constants.string.phoneNumber.localize()
        self.estimatedTitle.text = Constants.string.estimatedFare.localize()
        self.cancelBtn.setTitle(Constants.string.Cancel.localize(), for: .normal)
        self.confirmBtn.setTitle(Constants.string.confirm.localize(), for: .normal)
        
        self.cancelBtn.backgroundColor = .secondary
        self.confirmBtn.backgroundColor = .primary
        
    }
}

//MARK:- IBAction

extension InstantRideConfirmView {
    
    @IBAction func CancelBtnTapped(_ sender: Any) {
        
        self.removeFromSuperview()
        self.isHidden = true
        
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        
        var instantRide = instantRideModel()
        instantRide.s_latitude =  backGroundInstanse.userStoredDetail.latitude
        instantRide.s_longitude = backGroundInstanse.userStoredDetail.lontitude
        instantRide.d_latitude = d_lat
        instantRide.d_longitude = d_lang
        instantRide.mobile = mobile
        instantRide.s_address = PickUpAddressLbl.text
        instantRide.d_address = dropLocationAddressLbl.text
        instantRide.country_code = country_code
        self.presenter?.post(api: .instantRide, data: instantRide.toData())
        self.removeFromSuperview()
        self.isHidden = true
        
    }
    
}

//MARK:- PostViewProtocol

extension InstantRideConfirmView: PostViewProtocol {
   
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
        
        if api == .instantRide {
            
           self.make(toast: message)
        }
       
    }
    
    // Instant Ride
    func getSucessMessage(api: Base, data: String?) {
       
        if api == .instantRide {
             print("Success")
            DispatchQueue.main.async {
                self.onClickConfirm?(true)
            }
        }
    }
}
