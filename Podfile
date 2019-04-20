# Uncomment the next line to define a global platform for your project

 platform :ios, '10.0'

target 'Provider' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  #Alamofire for webservice
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  
  #Reachability Network check
  pod 'ReachabilitySwift'
  
  #Google
  pod 'GooglePlaces'
  pod 'GoogleSignIn'
  pod 'GoogleMaps'
  
  #Firebase
  pod 'Firebase/Database'
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  
  #Facebook
  pod 'AccountKit'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  
  #Payment & Bank
  pod 'Stripe'
  pod 'CreditCardForm', :git => 'https://github.com/orazz/CreditCardForm-iOS', branch: 'master'

  #Keyboard
  pod 'IQKeyboardManagerSwift'
  pod 'IHKeyboardAvoiding'

  #Crashlytics
  pod 'Fabric'
  pod 'Crashlytics'
  
  #Other
  pod 'SpinKit'
  pod 'Floaty'
  pod 'Lightbox'
  pod 'DropDown'
  pod 'PopupDialog'
  pod 'HCSStarRatingView'
  pod 'KWDrawerController'
  pod 'EFAutoScrollLabel'
  
  # Workaround for Cocoapods issue #7606
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end

end

