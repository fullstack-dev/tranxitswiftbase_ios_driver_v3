//
//  TransactionSummaryViewController.swift
//  Provider
//
//  Created by Sravani on 22/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TransactionSummaryViewController: UIViewController {
    
    // MARK:- IBOutlet
    
    @IBOutlet weak var tableViewTransaction: UITableView!
    
    // MARK:- Variable
    
    var transactionAlias :String?
    private var datasource = [Wallet_details]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialLoads()
        getTransactions()
        tableViewTransaction.tableFooterView = UIView()
    }
}

//MARK:- Methods
extension TransactionSummaryViewController {
    
    func initialLoads() {
        
        self.tableViewTransaction.register(UINib(nibName: XIB.Names.WalletListTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.WalletListTableViewCell)
        self.tableViewTransaction.register(UINib(nibName: XIB.Names.WalletHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: XIB.Names.WalletHeader)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.transaction.localize()
    }
    
    func getTransactions() {
        
        self.presenter?.get(api: .walletTransactionDetails, parameters: ["alias_id":transactionAlias!])
    }
}

//MARK:- UITableViewDataSource

extension TransactionSummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletListTableViewCell, for: indexPath) as? WalletListTableViewCell {
            if self.datasource.count > indexPath.row {
                tableCell.setTransaction(values: self.datasource[indexPath.row])
            }
            return tableCell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate

extension TransactionSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let walletHeader = Bundle.main.loadNibNamed(XIB.Names.WalletHeader, owner: self, options: [:])?.first as? WalletHeader
        walletHeader?.backgroundColor = .primary
        walletHeader?.fromTrascationDetails()
        return walletHeader
    }
}

//MARK:- PostViewProtocol

extension TransactionSummaryViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        if api == .walletTransactionDetails {
            print(message)
        }
    }
    
    func getWalletTransactionDetails(api: Base, data: TransactionDetailsEntity?) {
        
        if let datasource = data?.wallet_details {
            
            self.datasource = datasource
            tableViewTransaction.reloadData()
        }
    }
}
