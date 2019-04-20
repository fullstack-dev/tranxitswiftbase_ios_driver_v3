//
//  ReferalController.swift
//  Provider
//
//  Created by Ansar on 27/12/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ReferalController: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet private var viewShare : UIView!
    @IBOutlet private var lblReferMsg1 : Label!
    @IBOutlet private var lblReferMsg2 : Label!
    @IBOutlet private var lblReferralCode : UILabel!
    @IBOutlet private var lblReferHeading : UILabel!
    @IBOutlet private var imageGift : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}

//MARK:- LocalMethod

extension ReferalController {
    
    func initialLoads()  {
        SetNavigationcontroller()
        setCommonFont()
        localize()
        viewShare.makeRoundedCorner()
        self.imageGift.image = self.imageGift.image?.imageTintColor(color1: Color.valueFor(id: 2)!)
        self.lblReferralCode.text = User.main.referral_unique_id
        self.viewShare?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareReferal)))
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: lblReferMsg1, Button: nil, size: nil)
        setFont(TextField: nil, label: lblReferHeading, Button: nil, size: nil)
        setFont(TextField: nil, label: lblReferralCode, Button: nil, size: nil)
        if selectedLanguage == .arabic {
            self.lblReferMsg1.textAlignment = .left
            self.lblReferMsg2.textAlignment = .left
        }
        else {
            self.lblReferMsg1.textAlignment = .right
            self.lblReferMsg2.textAlignment = .right
        }
    }
    
    func SetNavigationcontroller(){
        
        if #available(iOS 11.0, *) {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = Constants.string.invideFriends.localize()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(helpViewController.backBarButtonTapped(button:)))
    }
    
    func share(items : [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
    }
    
    func localize() {
        
        self.lblReferHeading.text = Constants.string.referHeading.localize()
        self.lblReferMsg1.attributedText = setAttributeString(htmlText: User.main.referral_text!)
        self.lblReferMsg2.attributedText = setAttributeString(htmlText: User.main.referral_total_text!)
    }
    
    func setAttributeString(htmlText:String) -> NSAttributedString {
        var attributedText = NSAttributedString()
        if let htmlData = htmlText.data(using: String.Encoding.unicode) {
            do {
                attributedText = try NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't translate \(htmlText): \(e.localizedDescription) ")
            }
        }
        return attributedText
    }
}

extension ReferalController {
    
    @objc func backBarButtonTapped(button: UINavigationItem){
        self.popOrDismiss(animation: true)
    }
    
    @objc func shareReferal() {
        let  message = Constants.string.referalMessage.localize() + "\n\n" + "User: " + AppStoreUrl.user.rawValue + "\n Provider : " + AppStoreUrl.driver.rawValue + "\n\n" + Constants.string.installMessage.localize() + " \n " + User.main.referral_unique_id!
        let message1 = MessageWithSubject(subject: "Here is the subject", message: message)
        let itemsToShare:[Any] = [message1]
        self.share(items: itemsToShare)
    }
}

class MessageWithSubject: NSObject, UIActivityItemSource {
    
    let subject:String
    let message:String
    
    init(subject: String, message: String) {
        self.subject = subject
        self.message = message
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return message
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return message
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        if activityType == UIActivity.ActivityType.mail {
            print("Mail")
        }
        return subject
    }
}
