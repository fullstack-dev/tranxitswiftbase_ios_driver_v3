//
//  headerView.swift
//  User
//
//  Created by CSS on 13/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class headerView: UIView {
    
    @IBOutlet var labelTodaysCompletedTarget: UILabel!
    @IBOutlet var labelTodaysEarnings: UILabel!
    @IBOutlet var labelMoney: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        setCommonFont()
        self.localize()
    }

    private func setCommonFont(){
        
        setFont(TextField: nil, label: labelMoney, Button: nil, size: 40, with: true)
        setFont(TextField: nil, label: labelTodaysEarnings, Button: nil, size: nil)
        setFont(TextField: nil, label: labelTodaysCompletedTarget, Button: nil, size: nil)
    }
    
    private func localize() {
        self.labelTodaysCompletedTarget.text = Constants.string.todaysCompletedTarget.localize()
        self.labelTodaysEarnings.text = Constants.string.totalEarnings.localize()
    }

}
