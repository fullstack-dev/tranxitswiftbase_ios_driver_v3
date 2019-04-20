//
//  userinvoiceViewController.swift
//  User
//
//  Created by CSS on 16/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class userinvoiceViewController: UIViewController {
    
    
    //MARK:- IBOutlet

    @IBOutlet var labelCash: UILabel!
    @IBOutlet var labelInvoiceTitle: UILabel!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet var buttonPayNow: UIButton!
    @IBOutlet var imageInvoive: UIImageView!
    @IBOutlet var imageMoney: UIImageView!
    @IBOutlet var stackViewValues: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        localize()
    }
}

//MARK:- Method

extension userinvoiceViewController {
    
    private func localize(){
        
        for label in 0 ... labelCollection.count - 1 {
            print(labelCollection[label].text as Any)
            labelCollection[label].text = constantsArrry.array.invoiceArray[label].localize()
            print("Array: \(constantsArrry.array.invoiceArray[label])")
            
        }
        self.buttonPayNow.setTitle(Constants.string.payNow.localize(), for: .normal)
        self.labelCash.text = Constants.string.cash.localize()
        self.labelInvoiceTitle.text = Constants.string.invoice.localize()
    }
    
    private func setCommonFont(){
        for label in 0 ... labelCollection.count - 1 {
            setFont(TextField: nil, label: labelCollection[label], Button: nil, size: nil)
        }
        setFont(TextField: nil, label: labelInvoiceTitle, Button: buttonPayNow, size: nil)
        setFont(TextField: nil, label: labelCash, Button: nil, size:  nil)
        
    }
}











