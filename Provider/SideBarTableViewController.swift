//
//  SideBarTableViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    // MARK:- IBOutlet
    
    @IBOutlet var imageAccountStatus: UIImageView!
    @IBOutlet private var imageViewProfile : UIImageView!
    @IBOutlet private var labelName : UILabel!
    @IBOutlet private var viewShadow : UIView!
    @IBOutlet var labelEmail: UILabel!
    
    // MARK:- Variable
    
    var sideBarList = [Constants.string.yourTrips,
                       Constants.string.Earnings,
                       Constants.string.instantRide,
                       Constants.string.Summary,
                       Constants.string.wallet,
                       Constants.string.card,
                       Constants.string.help,
                       Constants.string.share,
                       Constants.string.settings,
                       Constants.string.notifications,
                       Constants.string.invideFriends,
                       Constants.string.logout]
    
    
    private let cellId = "cellId"
    private var isReferalEnable = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
        self.setValues()
        self.setAccountStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.presenter?.get(api: .settings, parameters: nil)
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setDesigns()
    }
}

// MARK:- Methods

extension SideBarTableViewController {
    
    private func initialLoads() {
        
        // self.drawerController?.fadeColor = UIColor
        self.drawerController?.shadowOpacity = 0.2
        let fadeWidth = self.view.frame.width*(1/5)
        //self.profileImageCenterContraint.constant = -(fadeWidth/2)
        self.drawerController?.drawerWidth = Float(self.view.frame.width - fadeWidth)
        self.viewShadow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAction)))
    }
    
    private func setAccountStatus() {
        
        if BackGroundTask.backGroundInstance.accountStatus == AccountStatus.banned {
            self.imageAccountStatus.image = selectedLanguage == .arabic ? #imageLiteral(resourceName: "Badge_Red_arabic") : #imageLiteral(resourceName: "Badge_Red")
        }else if BackGroundTask.backGroundInstance.accountStatus == AccountStatus.approved {
            self.imageAccountStatus.image = selectedLanguage == .arabic ? #imageLiteral(resourceName: "Badge_Green_arabic") : #imageLiteral(resourceName: "Badge_Green")
        }else {
            self.imageAccountStatus.image = selectedLanguage == .arabic ? #imageLiteral(resourceName: "Badge_Orange_arabic") : #imageLiteral(resourceName: "Badge_Orange")
        }
    }
    
    //Set Designs
    private func setDesigns(){
        
        // self.viewShadow.addShadow()
        self.imageViewProfile.makeRoundedCorner()
    }
    
    // Localize
    private func localize(){
        Common.setFont(to: labelName)
        Common.setFont(to: labelEmail, size : 10)
        self.tableView.reloadData()
        self.tableView.separatorStyle = .none
    }
    
    //SetValues
    private func setValues(){
        
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(String(describing: User.main.picture ?? "0"))") { (image) in
            DispatchQueue.main.async {
                self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "young-male-avatar-image") : image
            }
        }
        self.labelName.text = String.removeNil(User.main.firstName)+" "+String.removeNil(User.main.lastName)
        self.labelEmail.text = String.removeNil(User.main.email)
    }
    
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.logoutMessage.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            //self.loader.isHidden = false
            let user = User()
            user.id = User.main.id
            self.presenter?.post(api: .logout, data: user.toData())
            BackGroundTask.backGroundInstance.stopBackGroundTimer()
            BackGroundTask.backGroundInstance.backGroundTimer.invalidate()
            
            BackGroundTask.backGroundInstance.onbordingStatus = ""
            BackGroundTask.backGroundInstance.approvedStatus = ""
            BackGroundTask.backGroundInstance.bannedStatus = ""
            
        }
        
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.view.tintColor = .primary
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SideBarTableViewController {
    
    //ImageView Action
    @objc private func imageViewAction() {
        
        let profileVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.ProfileViewController)
        let baseVC = self.drawerController?.getViewController(for: .none) as! UINavigationController
        baseVC.pushViewController(profileVC, animated: true)
        self.drawerController?.closeSide()
    }
}

// MARK:- TableView

extension SideBarTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        tableCell.textLabel?.textColor = .secondary
        //tableCell.textLabel?.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 10)
        tableCell.textLabel?.text = sideBarList[indexPath.row].localize().capitalizingFirstLetter()
        tableCell.textLabel?.textAlignment = .left
        setFont(TextField: nil, label: tableCell.textLabel, Button: nil, size: nil)
        
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !User.main.isCardAllowed && indexPath.row == 5 { // If not is allowed hide it
            return 0
        }
        else if self.isReferalEnable == 0 && indexPath.row == 10 {
            return 0
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let baseVC = self.drawerController?.getViewController(for: .none) as? UINavigationController
        
        if indexPath.row == 0 {//yourtrips
            let yourTripVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.yourTripsPassbookViewController)
            baseVC?.pushViewController(yourTripVC, animated: true)
            
        }
        else if indexPath.row == 1 {//earnings
            
            let earningVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.EarningsViewController)
            baseVC?.pushViewController(earningVC, animated: true)
        }
        else if indexPath.row == 2 {//Instant Ride
            
            if isRide == true {
                UIApplication.shared.keyWindow?.makeToast("Please completed the ride and go for an instant ride")
                self.drawerController?.closeSide()
                return
            }
            
            let instantVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.HomepageViewController) as! HomepageViewController
            instantVC.isInstantRide = true
            baseVC?.pushViewController(instantVC, animated: true)
        }
        else if indexPath.row == 3 {//summary
            
            let summaryVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.summarytTableViewController)
            baseVC?.pushViewController(summaryVC, animated: true)
        }
        else if indexPath.row == 4{ //Wallet
            
            let walletVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletViewController)
            baseVC?.pushViewController(walletVC, animated: true)
        }
        else if indexPath.row == 5 {//Card
            
            let paymentVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PaymentViewController)
            baseVC?.pushViewController(paymentVC, animated: true)
        }
        else if indexPath.row == 6 {//help
            
            let helpVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.helpViewController)
            baseVC?.pushViewController(helpVC, animated: true)
        }
        else if  indexPath.row == 7 {//share
            
            ((self.drawerController?.getViewController(for: .none) as? UINavigationController)?.viewControllers.last as? HomepageViewController)?.share(items: ["\(AppName)", URL.init(string: baseUrl)!])
            
        }
        else if indexPath.row == 8 {
            
            let helpVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.SettingTableViewController)
            baseVC?.pushViewController(helpVC, animated: true)
        }
        else if indexPath.row == 9 {
            
            let helpVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.NotificationsViewController)
            baseVC?.pushViewController(helpVC, animated: true)
        }
        else if indexPath.row == 10 {
            
            let helpVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.ReferalController)
            baseVC?.pushViewController(helpVC, animated: true)
        }
        else {
            self.logout()
        }
        self.drawerController?.closeSide()
    }
}

// MARK:- PostViewProtocol

extension SideBarTableViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getSucessMessage(api: Base, data: String?) {
        
        print(data!)
        forceLogout()
    }
    
    func getSettings(api: Base, data: SettingsEntity) {
        
        self.isReferalEnable = Int((data.referral?.referral)!)!
        self.tableView.reloadInMainThread()
    }
}
