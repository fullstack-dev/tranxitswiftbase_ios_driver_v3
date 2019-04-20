//
//  Common.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import KWDrawerController
import Stripe

class Common {
    
    class func isValid(email : String)->Bool{
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@","[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
        
    }
    
    class func getBackButton()->UIBarButtonItem{
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        return backItem// This will show in the next view controller being pushed
    }
    
//    class func GMSAutoComplete(fromView : GMSAutocompleteViewControllerDelegate?)->GMSAutocompleteViewController{
//
//    let gmsAutoCompleteFilter = GMSAutocompleteFilter()
//    gmsAutoCompleteFilter.country =  GMSCountryCode
//    gmsAutoCompleteFilter.type = .city
//    let gmsAutoComplete = GMSAutocompleteViewController()
//    gmsAutoComplete.delegate = fromView
//    gmsAutoComplete.autocompleteFilter = gmsAutoCompleteFilter
//    return gmsAutoComplete
//    }
    
    
    class func getCurrentCode()->String?{
        
       return (Locale.current as NSLocale).object(forKey:  NSLocale.Key.countryCode) as? String
  
    }
    
    
    
    
    //MARK:- Get Countries from JSON
    
    class func getCountries()->[Country]{
        
        var source = [Country]()
        
        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countryCodes", ofType: "json") ?? "") as Data? {
            do{
                source = try JSONDecoder().decode([Country].self, from: data)
                
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return source
    }
    
    
    
    class func getRefreshControl(intableView tableView : UITableView, tintcolorId  : Int = Color.primary.rawValue, attributedText text : NSAttributedString? = nil)->UIRefreshControl{
       
        let rc = UIRefreshControl()
        rc.tintColorId = tintcolorId
        rc.attributedTitle = text
        tableView.addSubview(rc)
        return rc
        
    }
    
    class func getImageUrl (for urlString : String?)->String {
        
        return baseUrl+"/storage/"+String.removeNil(urlString)
    }
    
    class func getDirectUrl (for urlString : String?)->String {
        
        return baseUrl+String.removeNil(urlString)
    }
    
    
    class func storeUserData(from profile : Profile?){
        print("Updating defaults")
        User.main.id = profile?.id
        User.main.email = profile?.email
        User.main.firstName = profile?.first_name
        User.main.lastName = profile?.last_name
        User.main.mobile = profile?.mobile
        User.main.country_code = profile?.country_code
        User.main.serviceType = profile?.service?.service_type?.name
        User.main.serviceId = profile?.service?.service_type?.id
        User.main.picture = profile?.avatar
        User.main.currency  = profile?.currency
        User.main.walletBalance = profile?.wallet_balance
        User.main.measurement = profile?.measurement
        User.main.isCardAllowed = profile?.card == 1
        User.main.login_by = profile?.login_by
        User.main.referral_unique_id = profile?.referral_unique_id
        User.main.referral_count = profile?.referral_count
        User.main.referral_total_text = profile?.referral_total_text
        User.main.referral_text = profile?.referral_text
        User.main.otp = profile?.otp
        User.main.ride_otp = profile?.ride_otp
        User.main.service_number = profile?.service?.service_number
        User.main.service_model = profile?.service?.service_model
        
        if let language = profile?.profile?.language {
            UserDefaults.standard.set(language.rawValue, forKey: Keys.list.language)
            setLocalization(language: language)
        }
        
        if let stripeKey = profile?.stripe_publishable_key {
            User.main.stripeKey = stripeKey
            STPPaymentConfiguration.shared().publishableKey = stripeKey
        }
        
    }
    
    // MARK:- Set Font
    
    class func setFont(to field :Any, isTitle : Bool = false, size : CGFloat = 0) {
        
        let customSize = size > 0 ? size : (isTitle ? 18 : 16)
        let font = UIFont(name: isTitle ? FontCustom.bold.rawValue : FontCustom.medium.rawValue, size: customSize)
        switch (field.self) {
        case is UITextField:
            (field as? UITextField)?.font = font
            if [NSTextAlignment.left, .right].contains((field as! UITextField).textAlignment) {
                (field as? UITextField)?.textAlignment = (selectedLanguage == .arabic) ? .right : .left
            }
        case is UILabel:
            (field as? UILabel)?.font = font//UIFont(name: isTitle ? FontCustom.avenier_Heavy.rawValue : FontCustom.avenier_Medium.rawValue, size: customSize)
            if [NSTextAlignment.left, .right].contains((field as! UILabel).textAlignment) {
                (field as? UILabel)?.textAlignment = (selectedLanguage == .arabic) ? .right : .left
            }
        case is UIButton:
            (field as? UIButton)?.titleLabel?.font = font//UIFont(name: isTitle ? FontCustom.avenier_Heavy.rawValue : FontCustom.avenier_Medium.rawValue, size: customSize)
            if [UIControl.ContentHorizontalAlignment.left, .right].contains((field as! UIButton).contentHorizontalAlignment) {
                (field as! UIButton).contentHorizontalAlignment = (selectedLanguage == .arabic) ? .right : .left
            }
        case is UITextView:
            (field as? UITextView)?.font = font//UIFont(name: isTitle ? FontCustom.avenier_Heavy.rawValue : FontCustom.avenier_Medium.rawValue, size: customSize)
        default:
            break
        }
    }
    
    
    class func call(to number : String?) {
        if let providerNumber = number, let url = URL(string: "tel://\(providerNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.keyWindow?.make(toast: Constants.string.cannotMakeCallAtThisMoment.localize())
        }
    }
    
    // MARK:- Get Chat Id
    
    class func  getChatId(with requestId : Int?) -> String {
        
        guard let requestId = requestId else {
            return ProcessInfo().globallyUniqueString
        }
        return "\(requestId)"//userId <= provider ? "u\(userId)_p\(provider)" : "p\(provider)_u\(userId)"
        
    }
    
    //MARK:- Set Drawer Controller
    class func setDrawerController()->UIViewController {
        
        let drawerController =  DrawerController()
        if let sideBarController = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SideBarTableViewController) as? SideBarTableViewController  {
            //let drawerSide : DrawerSide = selectedLanguage == .arabic ? .right : .left
            let mainController = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchNavigationController)
            drawerController.setViewController(sideBarController, for: .left)
            drawerController.setViewController(sideBarController, for: .right)
            drawerController.setViewController(mainController, for: .none)
            drawerController.getSideOption(for: .left)?.isGesture = false
            drawerController.getSideOption(for: .right)?.isGesture = false 
        }
        return drawerController
    }
    
        
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
