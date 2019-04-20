//
//  WalletViewController.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class WalletViewController: UIViewController {
    
    // MARK:- IBOutlet
    
    @IBOutlet private weak var labelWalletString : UILabel!
    @IBOutlet private weak var labelWalletAmount : UILabel!
    @IBOutlet private weak var tableViewWallet : UITableView!
    @IBOutlet private weak var viewHeader : UIView!
    
    @IBOutlet private weak var textFieldAmount : UITextField!
    @IBOutlet private weak var labelAmount : UILabel!
    @IBOutlet private weak var viewAmount : UIView!
    @IBOutlet private weak var addMoneyButton : UIButton!
    
    // MARK:- Variable
    
    private var barbuttonTransfer : UIBarButtonItem!
    private var datasource = [WalletTransaction]()
    private var TrasactionData = [Transactions]()
    
    // add money or wallet history to check
    var isWalletAddMoney = false
    
    private var balance : Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.labelWalletAmount.text = "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(self.balance)", maximumDecimal: 2))"
                //self.barbuttonTransfer.isEnabled = self.balance > 0
                // self.barbuttonTransfer.tintColor = self.balance > 0 ? .secondary : .clear
            }
        }
    }
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialLoads()
        self.localize()
        self.setDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearCustom()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.hideAllToasts(includeActivity: true, clearQueue: true)
    }
}

// MARK:- Methods

extension WalletViewController {
    
    private func initialLoads() {
        
        self.tableViewWallet.tableHeaderView = viewHeader
        self.tableViewWallet.delegate = self
        self.tableViewWallet.dataSource = self
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletListTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.WalletListTableViewCell)
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: XIB.Names.WalletHeader)
        self.labelWalletAmount.text = "\(User.main.currency ?? .Empty) \(2222)"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.wallet.localize()
        self.barbuttonTransfer = UIBarButtonItem(image: #imageLiteral(resourceName: "transfer").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.buttonTransferAction))
        self.barbuttonTransfer.tintColor = .secondary
        self.navigationItem.rightBarButtonItem = self.barbuttonTransfer
        self.balance = User.main.walletBalance ?? 0
        self.navigationController?.isNavigationBarHidden = false
        
        self.textFieldAmount.placeholder = String.removeNil(User.main.currency)+" "+"\(0)"
        self.textFieldAmount.delegate = self
        
    }
    
    private func localize() {
        
        self.labelWalletString.text = Constants.string.walletAmount.localize()
        self.addMoneyButton.setTitle(Constants.string.addMoney.localize(), for: .normal)
        self.labelAmount.text = Constants.string.enterTheAmount.localize()
    }
    
    private func setDesign() {
        
        Common.setFont(to: labelWalletString, isTitle: true, size: 18)
        Common.setFont(to: labelWalletAmount, isTitle: true, size: 30)
    }
    
    private func viewWillAppearCustom() {
        self.balance = User.main.walletBalance ?? 0
        if !isWalletAddMoney {
            self.presenter?.get(api: .getWalletHistory, parameters: nil)
        }
        IQKeyboardManager.shared.enable = true
    }
    
    //Empty View
    private func checkEmptyView() {
        
        self.tableViewWallet.backgroundView = {
            
            if (self.datasource.count) == 0 {
                let label = Label(frame: UIScreen.main.bounds)
                label.numberOfLines = 0
                Common.setFont(to: label, isTitle: true)
                label.center = UIApplication.shared.keyWindow?.center ?? .zero
                label.backgroundColor = .clear
                label.textColorId = 2
                label.textAlignment = .center
                label.text = Constants.string.noTransactionsYet.localize()
                return label
            } else {
                return nil
            }
        }()
    }
    
    private func reloadTable() {
        
        DispatchQueue.main.async {
            self.checkEmptyView()
            self.tableViewWallet.reloadData()
        }
    }
}

// MARK:- IBAction

extension WalletViewController {
    
    @IBAction private func buttonSubmitAction() {
        
//        guard let text = textFieldAmount.text?.replacingOccurrences(of: String.removeNil(User.main.currency), with: "").removingWhitespaces(),  Float(text)! > 0  else {
//            self.view.make(toast: Constants.string.enterValidAmount.localize())
//            return
//        }
        if textFieldAmount.text == "" || textFieldAmount.text == String(Float(0)) {
            self.view.make(toast: Constants.string.enterValidAmount.localize())
            return
        }
        
        if let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PaymentViewController) as? PaymentViewController {
            paymentVC.isWallet = true
            paymentVC.onClickPaymentForWallet = { type, cardEntity in
                self.isWalletAddMoney = true
                var requestObj = AddMoneyEntity()
                requestObj.amount = self.textFieldAmount.text
                requestObj.card_id = cardEntity?.card_id
                requestObj.user_type = UserType.provider.rawValue
                requestObj.payment_mode = type.rawValue
                self.loader.isHidden = false
                self.presenter?.post(api: .addMoney , data: requestObj.toData())
            }
            self.textFieldAmount.resignFirstResponder()
            self.navigationController?.pushViewController(paymentVC, animated: true)
            
        }
    }
    
    @objc private func buttonTransferAction() {
        
        if self.balance <= 0 {
            UIApplication.shared.keyWindow?.make(toast: Constants.string.minimumBalance.localize())
        }
        else if let WalletTransferVC = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.WalletTransferViewController) as? WalletTransferViewController {
            self.navigationController?.pushViewController(WalletTransferVC, animated: true)
        }
    }
}

// MARK:- UITableViewDataSource

extension WalletViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletListTableViewCell, for: indexPath) as? WalletListTableViewCell {
            if self.datasource.count > indexPath.row {
                tableCell.set(values : self.datasource[indexPath.row])
            }
            return tableCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let walletHeader = Bundle.main.loadNibNamed(XIB.Names.WalletHeader, owner: self, options: [:])?.first as? WalletHeader
        walletHeader?.backgroundColor = .secondary
        return walletHeader
    }
}

// MARK:- UITableViewDelegate

extension WalletViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transactionList = self.datasource[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.TransactionSummaryViewController) as? TransactionSummaryViewController {
            vc.transactionAlias = transactionList.transaction_alias!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- UITextFieldDelegate

extension WalletViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //   print(IQKeyboardManager.sharedManager().keyboardDistanceFromTextField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}

// MARK:- PostViewProtocol

extension WalletViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getWalletEntity(api: Base, data: WalletEntity?) {
        if let balance = data?.wallet_balance, let datasource = data?.wallet_transation {
            self.balance = balance
            User.main.walletBalance = balance
            storeInUserDefaults()
            self.datasource = datasource
        }
       
        if isWalletAddMoney {
            if let balance = data?.wallet_balance {
                self.loader.isHideInMainThread(true)
                self.balance = balance
                User.main.walletBalance = balance
                self.textFieldAmount.text = ""
                self.view.makeToast(data?.message)
                storeInUserDefaults()
            }
        }
        self.reloadTable()
    }
}
