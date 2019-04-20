//
//  PaymentViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UITableViewController {
    
    // MARK:- IBOutlet

    @IBOutlet private var buttonAddPayments : UIButton!
    
    // MARK:- LocalVariable

    private let tableCellId = "tableCellId"
    private var headers = [Constants.string.paymentMethods]
    private var cardsList = [CardEntity]()
    private var totalCount = [Int:Int]()
    
    var isShowCash = true
    var isChangingPayment = false
    var isWallet = false
    
    private let cashSection = 0
    private let cardSection = 1
    
    var onclickPayment : ((PaymentType ,CardEntity?)->Void)?
    var onClickPaymentForWallet: ((PaymentType, CardEntity?)->Void)?
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        self.localize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.validatePaymentModes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

//MARK:- LocalMethod
extension PaymentViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: (self.isChangingPayment ? #imageLiteral(resourceName: "close-1") : #imageLiteral(resourceName: "back-icon")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonAction))
        self.navigationItem.title = Constants.string.payment.localize()
        self.setDesign()
        self.buttonAddPayments.addTarget(self, action: #selector(self.buttonPaymentAction), for: .touchUpInside)
    }
    
    //Validate Payment Types
    private func validatePaymentModes() {
        
        self.presenter?.get(api: .getCards, parameters: nil)
        self.buttonAddPayments.isHidden = false
        self.isShowCash = false
        let isShowCashRow =  (!isShowCash) ? 0 : 1
        totalCount.updateValue(isShowCashRow, forKey: cashSection) // Cash rows
        totalCount.updateValue(0, forKey: cardSection) // Card Row
    }
    
    //Set Design
    private func setDesign () {
        
        Common.setFont(to: buttonAddPayments)
    }
    
    private func localize() {
        
        buttonAddPayments.setTitle(Constants.string.addCardPayments.localize(), for: .normal)
    }
}

//MARK:- IBAction

extension PaymentViewController {
    
    @objc private func backButtonAction() {
        
        if isChangingPayment {
            self.navigationController?.popOrDismiss(animation: true)
        } else {
            self.popOrDismiss(animation: true)
        }
    }
    
    @objc private func buttonPaymentAction() {
        self.push(id: Storyboard.Ids.AddCardViewController, animation: true)
    }
}

//MARK:- TableView
extension PaymentViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return totalCount.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalCount[section] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? PaymentCell {
            
            if indexPath.section == 0  {
                tableCell.imageViewPayment.image =  #imageLiteral(resourceName: "money_icon")
                tableCell.labelPayment.text = Constants.string.cash.localize()
            } else if self.cardsList.count > indexPath.row {
                tableCell.imageViewPayment.image =  #imageLiteral(resourceName: "visa")
                tableCell.labelPayment.text = "XXXX-XXXX-XXXX-"+String.removeNil(cardsList[indexPath.row].last_four)
                tableCell.accessoryType = cardsList[indexPath.row].is_default == 1 ? .checkmark : .none
            }
            return tableCell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? headers[section].localize() : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if isWallet == true {
            if indexPath.section == 1, self.cardsList.count > indexPath.row {
                self.onClickPaymentForWallet?(.CARD,self.cardsList[indexPath.row])
                self.popOrDismiss(animation: true)
            }
        }
        
        guard self.isChangingPayment else { return }
        self.dismiss(animated: true) {
            if indexPath.section == 1, self.cardsList.count > indexPath.row {
                self.onclickPayment?(.CARD ,self.cardsList[indexPath.row])
            } else {
                self.onclickPayment?(.CASH, nil)
            }
        }
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    //Swipe Action
    @available(iOS 11.0, *)
    private func swipeAction(at indexPath : IndexPath) -> UISwipeActionsConfiguration?{
        
        guard indexPath.section == 1 && self.cardsList.count>1 else { return nil}
        let entity = self.cardsList[indexPath.row]
        let contextAction = UIContextualAction(style: .normal, title: Constants.string.delete.localize()) { (action, view, bool) in
            let alert = UIAlertController(title: "XXXX-XXXX-XXXX-"+String.removeNil(self.cardsList[indexPath.row].last_four), message: Constants.string.areYouSureCard.localize(), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Constants.string.remove.localize(), style: .destructive, handler: { (_) in
                self.loader.isHidden = false
                var cardEntity = CardEntity()
                cardEntity.card_id = entity.card_id
                cardEntity._method = Constants.string.delete.uppercased()
                self.presenter?.post(api: .deleteCard, data: cardEntity.toData())
                bool(true)
            }))
            alert.addAction(UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: { _ in
                bool(true)
            }))
            alert.view.tintColor = .primary
            self.present(alert, animated: true, completion: nil)
        }
        contextAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [contextAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK:- PostViewProtocol

extension PaymentViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getCardEnities(api: Base, data: [CardEntity]) {
        
        self.cardsList = data
        if User.main.isCardAllowed {
            self.totalCount.updateValue(self.cardsList.count, forKey: cardSection)
        }
        self.loader.isHideInMainThread(true)
        self.tableView.reloadInMainThread()
        
    }
    
    func getSucessMessage(api: Base, data: String?) {
        
        self.loader.isHideInMainThread(true)
        if api == .deleteCard {
            UIApplication.shared.keyWindow?.makeToast(data)
            self.presenter?.get(api: .getCards, parameters: nil)
        }
    }
}

//MARK:- UITableViewCell

class PaymentCell : UITableViewCell {
    
    @IBOutlet var imageViewPayment : UIImageView!
    @IBOutlet var labelPayment : UILabel!
}

