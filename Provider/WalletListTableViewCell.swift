//
//  WalletListTableViewCell.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalletListTableViewCell: UITableViewCell {
    
    // MARK:- IBOutlet

    @IBOutlet private weak var labelTransactionId : UILabel!
    @IBOutlet private weak var labelDate : UILabel!
    @IBOutlet private weak var labelAmount : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK:- LocalMethod

extension WalletListTableViewCell  {
    
    private func setDesign() {
        Common.setFont(to: labelAmount, size : 12)
        Common.setFont(to: labelTransactionId, size : 12)
        Common.setFont(to: labelDate, size : 12)
    }
    
    func set(values : WalletTransaction) {
        
        let createdDate = values.transactions
        print(createdDate as Any)
        self.set(date: values.created_at, amount: values.amount, tranId: values.transaction_alias ?? values.alias_id)
        self.labelAmount.textColor = values.type?.color
        
    }
    
    func setTransaction(values : Wallet_details) {
        self.setTrasanctionDetails(desc: values.transaction_desc, type: values.type, amount: values.amount)
        if  values.type == "C" {
            self.labelAmount.textColor = .green
            self.labelDate.text = "Credit"
        }else {
            self.labelDate.text = "Debit"
            self.labelAmount.textColor = .red
        }
    }
    
    private func set(date : String?, amount : Float?, tranId : String?) {
        if let dateObject = Formatter.shared.getDate(from: date, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss){
            self.labelDate.text = Formatter.shared.getString(from: dateObject, format: DateFormat.list.dd_MM_yyyy)
        }
        self.labelTransactionId.text = tranId
        self.labelAmount.text = "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(amount ?? 0)", maximumDecimal: 2))"
    }
    
    private func setTrasanctionDetails(desc : String?, type : String? ,amount : Double? ) {
        self.labelTransactionId.text = desc
        self.labelAmount.text = "\(User.main.currency ?? .Empty) \(amount ?? 0.0)"
    }
}
