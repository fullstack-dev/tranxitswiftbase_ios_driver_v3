//
//  helpViewController.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class helpViewController: UIViewController {
    
    //MARK:- IBOutlet

    @IBOutlet var supportLabel: UILabel!
    @IBOutlet var helpImage: UIImageView!
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var webImage: UIImageView!
    @IBOutlet var HelpQuotesLabel: UILabel!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var webButton: UIButton!
    @IBOutlet var viewMessage: View!
    @IBOutlet var viewWeb: View!
    @IBOutlet var viewCall: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetNavigationcontroller()
        localize()
        buttonAction()
        self.presenter?.get(api: .help, parameters: nil)
    }
    
    override func viewWillLayoutSubviews() {
        self.HelpQuotesLabel.textColor = UIColor.secondary
        viewCall.makeRoundedCorner()
        viewWeb.makeRoundedCorner()
        viewMessage.makeRoundedCorner()
    }
}

//MARK:- LocalMethod

extension helpViewController {
    
    func localize() {
        self.HelpQuotesLabel.text = Constants.string.helpQuotes.localize()
        self.supportLabel.text = Constants.string.support.localize()
    }
    
    func SetNavigationcontroller() {
        
        if #available(iOS 11.0, *) {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = Constants.string.help.localize()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(helpViewController.backBarButtonTapped(button:)))
    }
    
    private func setCommonFont() {
        
        setFont(TextField: nil, label: HelpQuotesLabel, Button: nil, size: nil)
        setFont(TextField: nil, label: supportLabel, Button: nil, size: nil)
    }
    
    private func buttonAction() {
        self.callButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.messageButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.webButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.callButton.tag = 1
        self.messageButton.tag = 2
        self.webButton.tag = 3
    }
}

//MARK:- IBAction

extension helpViewController {
    
    @objc func backBarButtonTapped(button: UINavigationItem){
        self.popOrDismiss(animation: true)
    }
    
    @objc func Buttontapped(sender: UIButton){
        if sender.tag == 1 {
            self.sendEmail()
        }else if sender.tag == 2 {
            Common.call(to: helpPhoneNumber)
        }else if sender.tag == 3 {
            
            guard let url = URL(string: baseUrl) else {
                UIScreen.main.focusedView?.make(toast: Constants.string.couldNotReachTheHost.localize())
                return
            }
            
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}

//MARK:- MFMailComposeViewControllerDelegate

extension helpViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([helpMail])
            mail.setSubject(helpEmailContant.localize())
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


//MARK:- SFSafariViewControllerDelegate

extension helpViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.popOrDismiss(animation: true)
    }
}

//MARK:- PostViewProtocol

extension helpViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getHelp(api: Base, data: HelpEntity) {
        helpMail = data.contact_email!
        helpPhoneNumber = data.contact_number!
    }
}
