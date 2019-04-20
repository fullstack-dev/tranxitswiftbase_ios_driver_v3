//
//  WalletHeader.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalletHeader: UIView {
    
    // MARK:- IBOutlet

    @IBOutlet private weak var labelTransactionId : UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var labelAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.setDesign()
    }
}

// MARK:- LocalMethod

extension WalletHeader {
    private func initialLoads() {
        self.labelTransactionId.text = Constants.string.transactionId.localize().uppercased()
        self.labelDate.text = Constants.string.date.localize().uppercased()
        self.labelAmount.text = Constants.string.amount.localize().uppercased()
    }
    
    func fromTrascationDetails() {
        self.labelTransactionId.text = Constants.string.description.localize()
        self.labelDate.text = Constants.string.type.localize()
        self.labelAmount.text = Constants.string.amount.localize()
    }
    
    private func setDesign() {
        Common.setFont(to: labelTransactionId, isTitle: true)
        Common.setFont(to: labelAmount, isTitle: true)
        Common.setFont(to: labelDate, isTitle: true)
    }
}
