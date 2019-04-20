//
//  Constants.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

typealias ViewController = (UIViewController & PostViewProtocol)
var presenterObject : PostPresenterInputProtocol?


//MARK:- Constant Strings

struct Constants {
    
    static let string = Constants()
    
    let Done = "Done"
    let Back = "Back"
    
    let noDevice = "no device"
    let noChatHistory = "No Chat History Found"
    let manual = "manual"
    let OK = "OK"
    let Cancel = "Cancel"
    let NA = "NA"
    let MobileNumber = "Mobile Number"
    let next = "Next"
    let selectSource = "Select Source"
    let camera = "Camera"
    let photoLibrary = "Photo Library"
    let welCome = "Welcome"
    let drive = "Drive"
    let earn = "Earn"
    let signIn = "SIGN IN"
    let signUp = "SIGNUP"
    let orConnectWithSocial = "Or connect with social"
    let walkthroughWelcome = "Introducing Tranxit Driver to take rides from the Tranxit app users."
    let walkthroughDrive = "Be your own boss, set your own schedule. Get the latest driving features all in one spot."
    let walkthroughEarn = "Get well paid to help out strangers get to where they need to go,withdraw your earnigs every week/monthly."
    let emailPlaceHolder = "name@example.com"
    let email = "Email"
    let iNeedTocreateAnAccount = "I need to create an account"
    let whatsYourEmailAddress = "What's your Email Address?"
    let welcomeBackPassword = "sign in to continue"//"Welcome back, sign in to continue"
    let enterPassword = "Enter Password"
    let password = "Password"
    let iForgotPassword = "I forgot my password"
    let enterYourMailIdForrecovery = "Enter your mail ID for recovery"
    let chooseAnAccount = "Choose an account"
    let facebook = "Facebook"
    let google = "Google"
    let payment = "Payment"
    let yourTrips = "Your Trips"
    let Earnings = "Earnings"
    let Summary = "Summary"
    let document = "Document"
    let passbook = "Passbook"
    let help = "Help"
    let share = "Share"
    let helpQuotes = "Our team persons will contact you soon!"
    let support = "Support"
    let accountNotVerifiedYet = "Your Account is not verified yet!, Please wait.."
    let balanceAlert = "Low Balance! Please settle the amount to admin"
    //let inviteReferral = "Invite Referral"
    let faqSupport = "FAQ Support"
    let termsAndConditions = "Terms and Conditions"
    let privacyPolicy = "Privacy Policy"
    let logout = "Logout"
    let settings = "Settings"
    let firsrName = "First Name"
    let lastName = "Last Name"
    let phoneNumber = "Phone Number"
    let vehicleMake = "VehicleMake"
    let vehicleModel = "VehicleModel"
    let vehicleYear = "VehicleYear"
    let Language = "Language"
    let vehicleColor = "VehicleColor"
    let vehiclePlateNumber = "VehiclePlateNumber"
    let city = "City"
    let carcategory = "Car Category"
    let referralCode = "Referral Code"
    let signUpNavTitle = "Enter the details to register"
    let notes = "Note: Please enter the OTP sent to your registered email address"
    let enterOTP = "Enter OTP"
    let enterNewPwd = "New Password"
    let oldPassword = "Old Password"
    let resetPassword = "Reset password"
    let ConfirmPassword = "Confirm Password"
    let country = "Country"
    let timeZone = "Time Zone"
    let business = "BUsiness"
    let personal = "Personal"
    let writeSomething = "Write Something"
    let couldNotReachTheHost = "Could not reach th web"
    let walletAmount = "Your Wallet Amount is"
    let wallet = "Wallet"
    let serviceType = "Service Type"
    let carNumber = "Car Number"
    let referalCode = "Referral Code (Optional)"
    let carModel = "Car Model"
    let referHeading = "Your Referral Code"
    let reasonForCancellation = "Reason For Cancellation"
    let othersIfAny = "Others If Any"
    let waitingTime = "Waiting Time"
    let readMore = "Show More"
    let readLess = "Show Less"
    let noNotifications = "No Notifications"
    
    let yes = "Yes"
    let no = "No"
    
    
    
    let debitErrormsg = "This card doesn't appear to be a debit card"
    
    //MARK:- sucess messages
    
    let loginSucess = "Login Sucessfully"
    let signUpSucess = "Registration Sucessfully Completed"
    let profileUpdatedSucess = "Profile Updated sucessfully"
    
    
    //MARK:- Invide referral page
    
    let title = "Invite Refreral"
    let referYourFriend = "Refer your friends to drive!"
    let givenFreeRide = "Given the free ride by reffering the invide code worth 10BCM"
    let shareYourCode = "Share your Invide code"
    let refferalEarning = "Refferal Earning"
    let totalMembers = "Total Members"
    let invideFriends = "Invite Friends"
    
    
    //MARK:- Summary page
    
    let totalNoOfRides = "TOTAL NO OF RIDES"
    let revenue = "REVENUE"
    let schueduleRides = "NO OF SCHEDULED RIDES"
    let cancelRides = "CANCELLED RIDES"
    let summary = "Summary"
    
    //MARK:- Document page
    
    //    let vehicleRegistration = "Vehicle Registration"
    //    let legalStatus = "Legal Status"
    //    let drivingAbstarct = "Driving Abstarct"
    //    let criminalRecord = "Criminal Record"
    let submit = "SUBMIT"
    //    let documents = "DOCUMENTS"
    //
    //MARK:- yourTrip Page
    
    let yourtrips = "Your trips"
    let past = "Past"
    let upcomming = "Upcomming"
    let bookedAnyRides = "You haven't any past trips."
    let findBookingDetails = "Find details of your bookings here."
    let upcomingNorides = "You haven't received upcoming rides."
    let upcomingBookingDetails = "Find details of your upcoming rides here."
    
    //MARK:- user invoice page
    
    let bookingId = "Booking ID"
    let distancetravelled = "Distance travelled"
    let timetaken = "Time Taken"
    let baseFare = "Base Fare"
    let distanceFare  = "Distance Fare"
    let tax = "Tax"
    let tips = "Tips"
    let total = "Total"
    let invoice = "Invoice"
    let cash = "cash"
    let payNow = "PAY NOW"
    
    //MARk:- Home Page constants
    
    let goOnline = "GO ONLINE"
    let goOffline = "GO OFFLINE"
    let pickedUp = "PICKEDUP"
    let tapWhenDropped = "TAP WHEN DROPPED"
    let dropped  = "DROPPED"
    let completed = "COMPLETED"
    let arrived = "ARRIVED"
    let offline = "offline"
    let active = "active"
    let storage = "storage"
    let pickUpLocation = "Pick Up Location"
    let dropLocation = "Drop Location"
    let drop = "Drop"
    let pickUp = "PickUp"
    
    
    //MARK:- yourtrips page Constants
    
    let inviteReferral   = "Invite Referral"
    let at = "at"
    
    //MARK:- yourtrip Detail
    let call = "Call"
    let viewRecipt = "View Receipt"
    let paymentMethod = "Payment Method"
    let payVia = "Pay via"
    let cancelRide = "Cancel Ride"
    let comments = "Comments"
    let upcomingTripDetails = "Upcoming Trip Details"
    let pastTripDetails = "Past Trip Details"
    let noComments = "No Comments"
    let rideCancel = "Ride cancelled sucessfully"
    
    //
    
    //MARK:- Earnings page Constants
    
    let enterTheDetails = "Enter the details"
    
    //MARK:- changePasswordAndresetPassword
    
    let enterOtp = "Enter OTP"
    let newPassword = "New Password"
    let enterCurrentPassword = "Enter Current Password"
    let changePassword = "Change Password"
    let resetPasswordDescription = "Note : Please enter the OTP send to your registered email address"
    let enterNewpassword = "Enter New Password"
    let enterConfirmPassword = "Enter Confirm Password"
    let otpIncorrect = "OTP incorrect"
    
    //MARK:- profile And Edit profile Constants
    let profile = "Profile"
    let save = "save"
    let lookingToChangePassword = "Looking to change password?"
    let latitude = "latitude"
    let longitude = "longitude"
    
    //MARK:- RatingView Page Constants
    let rateyourtrip = "Rate your trip with"
    let writeYourComments = "Write your comments"
    
    //MARK:- RideArrivedView Constants:
    let cannotMakeCallAtThisMoment = "Cannot make Call At the Moment"
    
    //MARK:- OTPScreen
    let wrongOTP = "Enter Valide OTP"
    
    //MARK:- Left Menu page
    let logoutMessage = "Do you want to logout?"
    let transactionId = "Transaction Id"
    let date = "Date"
    let amount = "Amount"
    let status = "Status"
    let transaction = "Transaction"
    let enterTheAmount = "Enter the Amount"
    let noTransactionsYet = "No Transactions yet"
    let enterValidAmount = "Enter valid amount"
    let availableCreditBalance = "Available credit balance"
    let cancelRequest = "Do you want to cancel request?"
    let ignore = "Ignore"
    let english = "English"
    let spanish = "Spanish"
    let arabic = "Arabic"
    let documents = "Documents"
    let delete = "Delete"
    let add = "Add"
    let edit = "Edit"
    let card = "Card"
    let paymentMethods = "Payment Methods"
    let addCard = "Add Card to continue with wallet"
    let allPaymentMethodsBlocked = "All payment methods has been blocked"
    let selectCardToContinue = "select card to continue"
    let addCardPayments = "Change card for payments"
    let areYouSureCard = "Are you sure want to delete this card?"
    let remove = "Remove"
    let upload = "Upload"
    let documentsUploadedSuccessfully = "Documents uploaded successfully!"
    let minimumBalance = "Minimum balance is required, for wallet transaction."
    let scheduledFor = "Scheduled for"
    let todaysCompletedTarget = "Today's Completed Target"
    let totalEarnings = "Total Earnings"
    let distance = "Distance"
    let time = "Time"
    let service = "Service"
    let accept = "Accept"
    let reject = "Reject"
    let amountToBePaid = "Amount to be paid"
    let confirmPayment = "Confirm Payment"
    let newVersionAvailableMessage = "A new version of this App is available in the App Store"
    let changePasswordMsg = "Password changed and please login with new password"
    
    //Referral
    let referalMessage = "Hey check this app \(AppName)"
    let installMessage = "Install this app with referral code"
    
    let notifications = "Notification Manager"
    let instantRide = "Instant Ride"
    let source = "Enter Phone number"
    let destination = "Destination"
    
    
    let changeDestination = "Ride Updated \n Destination Changed to"
    
    let addTollAmount = "Add Toll Amount"
    let dismiss = "Dismiss"
    let tollErrorMsg = "Enter Toll Amount"
    
    let dispute = "Dispute"
    let disputeStatus = "Dispute Status"
    let admin = "Admin"
    let you = "You"
    
    let disputeMsg = "Please choose dispute type"
    let enterComment = "Please enter your comments"
    let disputecreated = "Your Dispute already created"
    
    let pickUpLocationTitle = "Please confirm the address"
    let estimatedFare = "Estimated Fare"
    let confirm = "Confirm"
    
    let warningMsg = "You are using both user and driver apps in same device. So app may not work properly "
    let Continue = "Continue"
    
    let description = "Description"
    let type  = "Type"
    
    let addMoney = "Add Money"
    
}

struct constantsArrry {
    static let array = constantsArrry()
    
    let invoiceArray = ["Booking ID","Distance travelled","Time Taken","Base Fare","Distance Fare","Tax","Tips","Total"]
}


//Defaults Keys

struct Keys {
    
    static let list = Keys()
    let userData = "userData"
    
    let id = "id"
    let name = "name"
    let accessToken = "access_token"
    let latitude = "latitude"
    let lontitude = "lontitude"
    let coOrdinates = "coOrdinates"
    let firstName = "firstName"
    let lastName = "lastName"
    let picture = "picture"
    let email = "email"
    let mobile = "mobile"
    let country_code = "country_code"
    let serviceType = "serviceType"
    let seriviceId = "serviceId"
    let currency = "currency"
    let language = "Language"
    let isLoadedFirst = "isLoadedFirst"
    let isMovedToOnline = "isMovedToOnline"
    let walletBalance = "walletBalance"
    let measurement = "measurement"
    let card = "card"
    let stripe = "stripe"
    let login_by = "login_by"
    let referral_unique_id = "referral_unique_id"
    let referral_count = "referral_count"
    let referral_text = "referral_text"
    let referral_total_text = "referral_total_text"
    var otp = "otp"
    let ride_otp = "ride_otp"
    let service_model = "service_model"
    let service_number = "service_number"
    
    
}

//ENUM STATUS

enum ServiceStatus : String, Codable {
    case ONLINE = "active"
    case OFFLINE = "offline"
    case RIDING = "riding"
    case BALANCE = "balance"
    case NONE
    
    var stringValue : String {
        switch self {
        case .OFFLINE,.BALANCE, .NONE:
            return Constants.string.goOnline
        case .ONLINE, .RIDING:
            return Constants.string.goOffline
        }
    }
}


// Date Formats

struct DateFormat {
    
    static let list = DateFormat()
    
    let yyyy_mm_dd_HH_MM_ss = "yyyy-MM-dd HH:mm:ss"
    let MMM_dd_yyyy_hh_mm_ss_a = "MMM dd, yyyy hh:mm:ss a"
    let yyyymmddHHMMss = "yyyy-MM-dd HH:mm:ss"
    let hhMMTTA = "h:mm a"//"hh:MM TT a"
    let yyyymmdd = "yyyy-MM-dd"
    let ddmmmmyyyy = "dd MMMM yyyy"
    let yyyyMM = "yyyy-MM"
    let MMyyyy = "MMM.yyyy"
    let ddMMMyyyy = "dd MMM yyyy"
    let hh_mm_a = "hh : mm a"
    let dd_MM_yyyy = "dd/MM/yyyy"
}


// Devices

enum DeviceType : String, Codable {
    
    case ios = "ios"
    case android = "android"
    
}

//Lanugage

enum Language : String, Codable, CaseIterable {
    case english = "en"
    //case spanish = "es"
    case arabic = "ar"
    var code : String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
    
    var title : String {
        switch self {
        case .english:
            return Constants.string.english
        case .arabic:
            return Constants.string.arabic
        }
    }
    
    static var count: Int{ return 2 }
}

enum AccountStatus: String, Codable {
    case approved = "approved"
    case banned = "banned"
    case onboarding = "onboarding"
    case pendingDocument = "document"
    case pendingCard = "card"
    case none = "none"
    case balance = "balance"
}
enum OnlineStatus: String,Codable {
    case online = "online"
    case offline = "offline"
}

enum tripType: String {
    case Business = "Besiness"
    case Personal = "Personal"
}


enum requestType : String {
    case searching = "SEARCHING"
    case started = "STARTED"
    case arrived = "ARRIVED"
    case pickedUp  = "PICKEDUP"
    case dropped = "DROPPED"
    case completed = "COMPLETED"
}

// MARK:- Login Type

enum LoginType : String, Codable {
    
    case facebook
    case google
    case manual
}

enum defaultSystemSound : Float {
    case peek = 1519
    case pop = 1520
    case cancelled = 1521
    case tryAgain = 1102
    case Failed = 1107
}

//Dispute Status

enum DisputeStatus : String, Codable {
    
    case open
    case closed
    
}


//Payment Type

enum  PaymentType : String, Codable {
    
    case CASH = "CASH"
    case CARD = "CARD"
    case NONE = "NONE"
    
    var image : UIImage? {
        var name = "ic_error"
        switch self {
        case .CARD:
            name = "visa"
        case .CASH:
            name = "money_icon"
        case .NONE :
            name = "ic_error"
        }
        return UIImage(named: name)
    }
}

enum TransactionType : String, Codable {
    case credit = "C"
    case debit = "D"
    
    var color : UIColor {
        switch self {
        case .credit:
            return .green
        case .debit:
            return .red
        }
    }
}
