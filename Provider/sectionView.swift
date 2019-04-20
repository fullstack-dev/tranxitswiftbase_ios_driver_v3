//
//  sectionView.swift
//  User
//
//  Created by CSS on 13/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class sectionView: UIView {

    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var labelDistance: UILabel!

    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       self.setCommonFont()
       self.localize()
    }
    
    private func setCommonFont(){
        
        setFont(TextField: nil, label: labelTime, Button: nil, size: nil)
        setFont(TextField: nil, label: labelAmount, Button: nil, size: nil)
        setFont(TextField: nil, label: labelDistance, Button: nil, size: nil)
    }
 
    private func localize() {
        self.labelAmount.text = Constants.string.amount.localize().uppercased()
        self.labelTime.text = Constants.string.time.localize().uppercased()
        self.labelDistance.text = Constants.string.distance.localize().uppercased()
    }

}
