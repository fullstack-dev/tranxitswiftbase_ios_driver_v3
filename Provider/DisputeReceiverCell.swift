//
//  DisputeReceiverCell.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeReceiverCell: UITableViewCell {

    @IBOutlet var imgProfile:UIImageView!
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblContent:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setFont() {
        Common.setFont(to: lblName, isTitle: true, size: 16)
        Common.setFont(to: lblContent, isTitle: false, size: 14)
        imgProfile.makeRoundedCorner()
        self.lblName.textAlignment = selectedLanguage == .arabic ? .left : .right
        self.lblContent.textAlignment = selectedLanguage == .arabic ? .left : .right
        imgProfile.image = #imageLiteral(resourceName: "Splash_icon")
    }
}
