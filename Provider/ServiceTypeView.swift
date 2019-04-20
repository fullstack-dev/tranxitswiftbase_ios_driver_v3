//
//  ReasonView.swift
//  User
//
//  Created by CSS on 26/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ServiceTypeView: UIView {

    // MARK:- IBOutlet

    @IBOutlet private weak var tableview : UITableView!
    @IBOutlet private weak var scrollView : UIScrollView!
    @IBOutlet private weak var labelTitle : UILabel!
    
    // MARK:- LocalVariable

    var datasource : [serviceTypes] = []
    var didSelectReason : ((String)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.register(UINib(nibName: XIB.Names.serviceTypeCell, bundle: nil), forCellReuseIdentifier: XIB.Names.serviceTypeCell)
        Common.setFont(to: labelTitle)
        labelTitle.text = ""
    }
}

// MARK:- UITableViewDataSource

extension ServiceTypeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableview.dequeueReusableCell(withIdentifier: XIB.Names.serviceTypeCell, for: indexPath) as? ServiceTypeCell, self.datasource.count > indexPath.row {
            tableCell.textLabel?.text = self.datasource[indexPath.row].name
            Common.setFont(to:  tableCell.textLabel!)
            return tableCell
        }
        return UITableViewCell()
    }
}

// MARK:- UITableViewDelegate

extension ServiceTypeView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK:- UIScrollViewDelegate

extension ServiceTypeView: UIScrollViewDelegate {
    
}




