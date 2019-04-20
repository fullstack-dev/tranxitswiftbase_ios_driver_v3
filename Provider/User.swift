//
//  User.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//


import Foundation

class User : NSObject, NSCoding, JSONSerializable {
    
    static var main = User()
    
    var id : Int?
    var name : String?
    var accessToken : String?
    var latitude : Double?
    var lontitude : Double?
    var firstName : String?
    var lastName :String?
    var picture : String?
    var email : String?
    var mobile : String?
    var country_code: String?
    var currency : String?
    var serviceType : String?
    var service_model : String?
    var service_number : String?
    var serviceId : Int?
    var walletBalance : Float?
    var measurement : String?
    var isCardAllowed : Bool
    var stripeKey : String?
    var login_by : String?
    var referral_count :String?
    var referral_unique_id : String?
    var referral_total_text : String?
    var referral_text : String?
    var otp : Int?
    var ride_otp : Int?
    
    init(id : Int?, name : String?, accessToken: String?, latitude: Double?, lontitude: Double?, firstName: String?, lastName : String?, email : String?, phoneNumber: String?, country_code: String?, serviceType: String?,serviceId: Int?,picture: String?, currency : String?, walletBalance : Float?, measurement : String?, isCardAllowed : Bool, stripeKey : String?,login_by:String?,referral_count:String?,referral_unique_id:String?,referral_total_text:String?,referral_text:String?,otp:Int?,ride_otp:Int?,service_model:String?,service_number:String?){
        
        self.id = id
        self.name = name
        self.accessToken = accessToken
        self.latitude = latitude
        self.lontitude = lontitude
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = phoneNumber
        self.country_code = country_code
        self.email = email
        self.serviceType = serviceType
        self.serviceId = serviceId
        self.picture = picture
        self.currency = currency
        self.walletBalance = walletBalance
        self.measurement = measurement
        self.isCardAllowed = isCardAllowed
        self.stripeKey = stripeKey
        self.login_by = login_by
        self.referral_count = referral_count
        self.referral_unique_id = referral_unique_id
        self.referral_total_text = referral_total_text
        self.referral_text = referral_text
        self.otp = otp
        self.ride_otp = ride_otp
        self.service_model = service_model
        self.service_number = service_number
    }
    
    convenience
    override init(){
        
        self.init(id: nil, name: nil, accessToken: nil, latitude: nil, lontitude: nil, firstName: nil, lastName: nil, email: nil, phoneNumber:  nil, country_code: nil, serviceType: nil,serviceId: nil, picture: nil, currency: nil, walletBalance : nil,measurement : "km", isCardAllowed:true, stripeKey: nil,login_by:nil,referral_count:nil,referral_unique_id:nil,referral_total_text:nil,referral_text:nil,otp:nil,ride_otp:nil,service_model:nil, service_number:nil)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: Keys.list.id) as? Int
        let name = aDecoder.decodeObject(forKey: Keys.list.name) as? String
        let accessToken = aDecoder.decodeObject(forKey: Keys.list.accessToken) as? String
        let latitude = aDecoder.decodeObject(forKey: Keys.list.latitude) as? Double
        let lontitude = aDecoder.decodeObject(forKey: Keys.list.lontitude) as? Double
        let firstNmae = aDecoder.decodeObject(forKey: Keys.list.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: Keys.list.lastName) as? String
        let email = aDecoder.decodeObject(forKey: Keys.list.email) as? String
        let phoneNumber = aDecoder.decodeObject(forKey: Keys.list.mobile) as? String
        let country_code = aDecoder.decodeObject(forKey: Keys.list.country_code) as? String
        let serviceType = aDecoder.decodeObject(forKey: Keys.list.serviceType) as? String
        let serviceId = aDecoder.decodeObject(forKey: Keys.list.seriviceId) as? Int
        let picture = aDecoder.decodeObject(forKey: Keys.list.picture) as? String
        let currency = aDecoder.decodeObject(forKey: Keys.list.currency) as? String
        let walletBalance = aDecoder.decodeObject(forKey: Keys.list.walletBalance) as? Float
        let measurement = aDecoder.decodeObject(forKey: Keys.list.measurement) as? String
        let isCardAllowed = aDecoder.decodeInteger(forKey: Keys.list.card) == 1
        let stripeKey = aDecoder.decodeObject(forKey: Keys.list.stripe) as? String
        let login_by = aDecoder.decodeObject(forKey: Keys.list.login_by) as? String
        let referral_count = aDecoder.decodeObject(forKey: Keys.list.referral_count) as? String
        let referral_unique_id = aDecoder.decodeObject(forKey: Keys.list.referral_unique_id) as? String
        let referral_text = aDecoder.decodeObject(forKey: Keys.list.referral_text) as? String
        let referral_total_text = aDecoder.decodeObject(forKey: Keys.list.referral_total_text) as? String
        let otp = aDecoder.decodeObject(forKey: Keys.list.otp) as? Int
        let ride_otp = aDecoder.decodeObject(forKey: Keys.list.ride_otp) as? Int
        let service_model = aDecoder.decodeObject(forKey: Keys.list.service_model) as? String
        let service_number = aDecoder.decodeObject(forKey: Keys.list.service_number) as? String
        
        
        
        
        self.init(id: id, name: name, accessToken: accessToken, latitude: latitude, lontitude: lontitude, firstName: firstNmae, lastName: lastName, email: email, phoneNumber: phoneNumber, country_code: country_code, serviceType: serviceType, serviceId : serviceId, picture: picture, currency: currency, walletBalance : walletBalance, measurement : measurement, isCardAllowed : isCardAllowed, stripeKey : stripeKey,login_by:login_by,referral_count:referral_count,referral_unique_id:referral_unique_id,referral_total_text:referral_total_text,referral_text:referral_text,otp:otp,ride_otp:ride_otp,service_model:service_model,service_number:service_number)
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Keys.list.id)
        aCoder.encode(self.name, forKey: Keys.list.name)
        aCoder.encode(self.accessToken, forKey: Keys.list.accessToken)
        aCoder.encode(self.lontitude, forKey: Keys.list.lontitude)
        aCoder.encode(self.latitude, forKey: Keys.list.latitude)
        aCoder.encode(self.firstName, forKey: Keys.list.firstName)
        aCoder.encode(self.lastName, forKey: Keys.list.lastName)
        aCoder.encode(self.email, forKey: Keys.list.email)
        aCoder.encode(self.mobile, forKey: Keys.list.mobile)
        aCoder.encode(self.country_code, forKey: Keys.list.country_code)
        aCoder.encode(self.serviceType, forKey: Keys.list.serviceType)
        aCoder.encode(self.serviceId, forKey: Keys.list.seriviceId)
        aCoder.encode(self.picture, forKey: Keys.list.picture)
        aCoder.encode(self.currency, forKey: Keys.list.currency)
        aCoder.encode(self.walletBalance, forKey: Keys.list.walletBalance)
        aCoder.encode(self.measurement, forKey: Keys.list.measurement)
        aCoder.encode(self.isCardAllowed ? 1 : 0 , forKey: Keys.list.card)
        aCoder.encode(self.stripeKey , forKey: Keys.list.stripe)
        aCoder.encode(self.login_by , forKey: Keys.list.login_by)
        aCoder.encode(self.referral_unique_id , forKey: Keys.list.referral_unique_id)
        aCoder.encode(self.referral_count , forKey: Keys.list.referral_count)
        aCoder.encode(self.referral_text , forKey: Keys.list.referral_text)
        aCoder.encode(self.referral_total_text , forKey: Keys.list.referral_total_text)
        aCoder.encode(self.otp , forKey: Keys.list.otp)
        aCoder.encode(self.ride_otp , forKey: Keys.list.ride_otp)
        aCoder.encode(self.service_model , forKey: Keys.list.service_model)
        aCoder.encode(self.service_number , forKey: Keys.list.service_number)
        
    }
    
    
    
    
}









