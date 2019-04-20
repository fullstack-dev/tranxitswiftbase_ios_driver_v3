
//
//  AppDelegate.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMaps
import IQKeyboardManagerSwift
import GoogleSignIn
import Firebase
import Stripe
import FirebaseDatabase
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locationManager:CLLocationManager!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        self.appearence()
        Database.database().isPersistenceEnabled = true
        IQKeyboardManager.shared.enable = false
        self.setgoogleMap()
        registerPush(forApp: application)
        setGoogleSignIn()
        stripe()
        let navigationController =  Router.setWireFrame()
        //Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletViewController) //
        //let nav = UINavigationController(rootViewController: navigationController)
         //nav.isNavigationBarHidden = true
         window?.rootViewController = navigationController
         window?.makeKeyAndVisible()
        initiateLocationManager()
        self.checkUpdates()
        //print(launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification])
        Fabric.sharedSDK().debug = true
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
       
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
  
}

extension AppDelegate {
    
    //MARK:- Appearence
    private func appearence() {
        
        if let languageStr = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: languageStr) {
            setLocalization(language: language)
        }else {
            setLocalization(language: .english)
        }
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        var attributes = [NSAttributedString.Key : Any]()
        attributes.updateValue(UIColor.black, forKey: .foregroundColor)
        attributes.updateValue(UIFont(name: "Avenir-Heavy", size: 16)!, forKey : NSAttributedString.Key.font)
        UINavigationBar.appearance().titleTextAttributes = attributes
        attributes.updateValue(UIFont(name: "Avenir-Heavy", size: 16)!, forKey : NSAttributedString.Key.font)
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = attributes
        }
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .primary
        UIPageControl.appearance().backgroundColor = .clear
    }
    
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        
    }
    
    private func setgoogleMap(){
         GMSServices.provideAPIKey(googleMapKey)
         GMSPlacesClient.provideAPIKey(googleMapKey)
    }
    
    private func setGoogleSignIn(){
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID 
       
    }
    
    //MARK:- Stripe
    
    private func stripe(){
        
        STPPaymentConfiguration.shared().publishableKey = User.main.stripeKey ?? stripePublishableKey
    }
    
    // MARK:- Check Update
    private func checkUpdates() {
        
        var request = ChatPush()
        request.version = Bundle.main.getVersion()
        request.device_type = .ios
        request.sender = .provider
        Webservice().retrieve(api: .versionCheck, url: nil, data: request.toData(), imageData: nil, paramters: nil, type: .POST) { (error, data) in
            guard let responseObject = data?.getDecodedObject(from: ChatPush.self),
                  let forceUpdate = responseObject.force_update,
                  forceUpdate,
                  let appUrl = responseObject.url,
                  let urlObject = URL(string: appUrl),
                  UIApplication.shared.canOpenURL(urlObject)
            else {
                return
            }
            
            func showUpdateUI() {
              DispatchQueue.main.async {
                    let alert = showAlert(message: Constants.string.newVersionAvailableMessage.localize(), handler: { (_) in
                        UIApplication.shared.open(urlObject, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        showUpdateUI()
                    })
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                }
            }
            showUpdateUI()
        }
    }
    
}



extension AppDelegate {
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        //Messaging.messaging().apnsToken = deviceToken
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Apn Token ", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
        
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        print("Notification  :  ", notification)

        let notificationType = notification["type"] as? String
        if notificationType == "chat" && notificationType != nil {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ChatPushRedirection"), object: nil)
            
        }
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
         print("Error in Notification  \(error.localizedDescription)")
    }

    
    func initiateLocationManager(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if #available(iOS 11.0, *) {
             locationManager.showsBackgroundLocationIndicator = true
        }
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    

    
}

extension AppDelegate: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationCordinates : CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        print(locationCordinates.latitude)
        print(locationCordinates.longitude)
        BackGroundTask.backGroundInstance.userStoredDetail.latitude = locationCordinates.latitude
        BackGroundTask.backGroundInstance.userStoredDetail.lontitude = locationCordinates.longitude
        
       // print("locatoon:>> \(BackGroundTask.backGroundInstance.userStoredDetail.latitude), \(BackGroundTask.backGroundInstance.userStoredDetail.lontitude)")
        
    }

}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
