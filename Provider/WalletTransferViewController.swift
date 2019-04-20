//
//  WalletTransferViewController.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import Foundation
import PopupDialog

class WalletTransferViewController: UIViewController {
    
    // MARK:- IBOutlet
    
    @IBOutlet private weak var tableViewWallet : UITableView!
    @IBOutlet private weak var buttonSubmit : UIButton!
    @IBOutlet private weak var textFieldAmount : UITextField!
    @IBOutlet private weak var labelAmount : UILabel!
    @IBOutlet private weak var viewAmount : UIView!
    @IBOutlet private weak var viewHeader : UIView!
    
    // MARK:- Variable
    
    private var datasource = [WalletTransaction]()
    private var availableCreditBalance: Float = 0
    private var requestId = 0
    
    private var onCompleteCancel : ((Bool)->Void)?
    private lazy var loader : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        self.localize()
        self.setDesign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearCustom()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewWallet.frame.width, height: 200)
    }
}


//MARK:- Methods

extension WalletTransferViewController {
    
    private func initialLoads() {
        
        self.tableViewWallet.tableHeaderView = viewHeader
        self.tableViewWallet.delegate = self
        self.tableViewWallet.dataSource = self
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletListTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.WalletListTableViewCell)
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: XIB.Names.WalletHeader)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.transaction.localize()
        self.buttonSubmit.addTarget(self, action: #selector(self.buttonSubmitAction), for: .touchUpInside)
        self.textFieldAmount.delegate = self
        self.presenter?.get(api: .pendingTransferList, parameters: nil)
        self.reloadTable()
        self.availableCreditBalance = Float.removeNil(User.main.walletBalance)
    }
    
    private func viewWillAppearCustom() {
        
        KeyboardAvoiding.avoidingView = viewAmount
    }
    
    private func localize() {
        
        self.buttonSubmit.setTitle(Constants.string.submit.localize().uppercased(), for: .normal)
        self.labelAmount.text = Constants.string.enterTheAmount.localize()
        self.textFieldAmount.placeholder = Constants.string.enterTheAmount.localize()
    }
    
    private func setDesign() {
        
        Common.setFont(to: buttonSubmit, isTitle: true)
        Common.setFont(to: textFieldAmount)
        Common.setFont(to: labelAmount, isTitle: true)
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
            }
            else {
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

extension WalletTransferViewController {
    
    @objc private func buttonSubmitAction() {
        self.textFieldAmount.endEditingForce()
        self.textFieldAmount.resignFirstResponder()
        self.viewHeader.endEditingForce()
        guard let requestAmount = self.textFieldAmount.text, let amount = Float(requestAmount),amount > 0 else {
            self.viewAmount.shake()
            self.viewHeader.make(toast: Constants.string.enterValidAmount.localize())
            return
        }
        
        guard amount<=self.availableCreditBalance  else {
            self.viewAmount.shake()
            self.viewHeader.make(toast: Constants.string.availableCreditBalance.localize()+" \(User.main.currency ?? .Empty)\(Formatter.shared.limit(string: "\(availableCreditBalance)", maximumDecimal: 2))")
            return
        }
        
        self.loader.isHidden = false
        var walletRequest = WalletEntity()
        walletRequest.amount = amount
        walletRequest.type = .provider
        self.presenter?.post(api: .requestAmount, data: walletRequest.toData())
    }
}

// MARK:- UITableViewDataSource

extension WalletTransferViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletListTableViewCell, for: indexPath) as? WalletListTableViewCell {
            if self.datasource.count>indexPath.row {
                tableCell.set(values: self.datasource[indexPath.row])
            }
            return tableCell
        }
        return UITableViewCell()
    }
}

// MARK:- UITableViewDelegate

extension WalletTransferViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let walletHeader = Bundle.main.loadNibNamed(XIB.Names.WalletHeader, owner: self, options: [:])?.first as? WalletHeader
        walletHeader?.backgroundColor = .secondary
        return walletHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return self.trailingSwipeAction(at: indexPath)
    }
    
    //railin Swipe Action At IndexPath
    @available(iOS 11.0, *)
    private func trailingSwipeAction(at indexPath : IndexPath)->UISwipeActionsConfiguration?{
        
        guard self.datasource.count > indexPath.row, let id = self.datasource[indexPath.row].id else {
            return nil
        }
        
        let clearAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: Constants.string.Cancel.localize()) { (action, view, completion) in
            
            showAlert(message: Constants.string.cancelRequest.localize(), okHandler: { [weak self] isOkClikced in
                guard let self = self else {return}
                if isOkClikced {
                    self.onCompleteCancel = completion
                    self.loader.isHidden = false
                    self.presenter?.get(api: .cancelTransferRequest, parameters: [WebConstants.string.id:id])
                }else {
                    completion(false)
                }
                }, fromView: self, isShowCancel: true, okTitle: Constants.string.Cancel, cancelTitle: Constants.string.ignore)
            
            
        }
        clearAction.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [clearAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK:- UITextFieldDelegate

extension WalletTransferViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text ?? .Empty
        text = range.length == 0 ? (text+string) : text
        let arr = text.split(separator: ".")
        if arr.count>1, arr[1].count>2{
            return false
        }
        return true
    }
}

// MARK:- PostViewProtocol

extension WalletTransferViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        self.loader.isHideInMainThread(true)
        DispatchQueue.main.async {
            self.onCompleteCancel?(false)
            self.viewHeader.make(toast: message)
        }
    }
    
    func getSucessMessage(api: Base, data: String?) {
        
        self.loader.isHideInMainThread(true)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.makeToast(data)
            self.onCompleteCancel?(true)
            if api == .cancelTransferRequest ,self.requestId>0, let index = self.datasource.firstIndex(where: { $0.id == self.requestId }) {
                self.availableCreditBalance += Float.removeNil(self.datasource[index].amount)
                self.datasource.remove(at: index)
                self.tableViewWallet.beginUpdates()
                self.tableViewWallet.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.tableViewWallet.endUpdates()
                self.requestId = 0
            }
            else if api == .requestAmount {
                self.textFieldAmount.text = nil
            }
        }
        self.presenter?.get(api: .pendingTransferList, parameters: nil)
    }
    
    func getWalletEntity(api: Base, data: WalletEntity?) {
        
        if let balance = data?.wallet_balance, let datasource = data?.pendinglist {
            self.datasource = datasource
            let creditedAmount : Float = self.datasource.reduce(into: 0, { (res, tran) in
                res = res + Float.removeNil(tran.amount)
                print(res)
            })
            self.availableCreditBalance = Float.removeNil(User.main.walletBalance)-creditedAmount
            User.main.walletBalance = balance
            storeInUserDefaults()
        }
        self.reloadTable()
    }
}
