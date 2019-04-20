//
//  LocationSelectionView.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSelectionView: UIView {
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableViewBottom: UITableView!
    @IBOutlet private weak var viewBack: UIView!
    @IBOutlet  weak var textFieldSource: UITextField!
    @IBOutlet  weak var textFieldDestination: UITextField!
    @IBOutlet weak var QRBtn: UIButton!
    @IBOutlet weak var countryCodeTextFileld: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    //MARK:- LocalVariable
    
    var backGroundInstanse = BackGroundTask.backGroundInstance
    var locationDetail : LocationDetail?
    var currentAddress : String?
    var estimatedAlert : InstantRideConfirmView?
    var homeView : HomepageViewController?
    private var googlePlacesHelper : GooglePlacesHelper?
    
    typealias Address = (source : Bind<LocationDetail>?,destination : LocationDetail?)
    private var completion : ((Address)->Void)? // On dismiss send address
    var onClickInstantRideBackBtn : ((Bool)->Void)? // on Instant back button

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.setDesign()
    }
    
    private var address : Address? {
        didSet{
            if address?.source != nil {
                self.textFieldSource.text = self.address?.source?.value?.address
            }
            if address?.destination != nil {
                self.textFieldDestination.text = self.address?.destination?.address
            }
        }
    }
    
    
    private var datasource = [GMSAutocompletePrediction]() {  // Predictions List
        didSet {
            DispatchQueue.main.async {
                print("Reloaded")
                self.tableViewBottom.reloadData()
            }
        }
    }
}

extension LocationSelectionView {
    
    // MARK:- Set Designs
    private func setDesign() {
        Common.setFont(to: textFieldSource)
        Common.setFont(to: textFieldDestination)
        Common.setFont(to: doneButton)
    }
    
    private func localize() {
        
        self.textFieldSource.placeholder = Constants.string.source.localize()
        self.textFieldDestination.placeholder = Constants.string.destination.localize()
        self.doneButton.setTitle(Constants.string.Done.localize(), for: .normal)
    }
    
    private func getPredications(from string : String?){
        self.googlePlacesHelper?.getAutoComplete(with: string, with: { (predictions) in
            self.datasource = predictions
        })
    }
    
    private func initialLoads() {
        self.localize()
        self.googlePlacesHelper = GooglePlacesHelper()
        self.tableViewBottom.isHidden = true
        self.viewTop.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.viewTop.alpha = 1
        }) { _ in
            self.tableViewBottom.isHidden = true
            self.tableViewBottom.show(with: .bottom, duration: 0.3, completion: nil)
        }
        self.tableViewBottom.delegate = self
        self.tableViewBottom.dataSource = self
        self.textFieldSource.delegate = self
        self.textFieldDestination.delegate = self
        self.countryCodeTextFileld.delegate = self
        
        self.tableViewBottom.register(UINib(nibName: XIB.Names.LocationTableViewCell, bundle: nil), forCellReuseIdentifier:XIB.Names.LocationTableViewCell)
        self.viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backButtonAction)))
        self.QRBtn.addTarget(self, action: #selector(self.QRCodeTapped), for: .touchUpInside)
        let lat = backGroundInstanse.userStoredDetail.latitude
        let lang = backGroundInstanse.userStoredDetail.lontitude
        if lat != nil || lang != nil {
            getAddressFromLatLon(pdblLatitude: "\(String(describing: lat!))", withLongitude: "\(String(describing: lang!))")
        }
        automaticCountryCodeFetch()
    }
    
    // Auto Fill At
    private func autoFill(with location : LocationDetail?){ //, with array : [T]
        
        if textFieldSource.isEditing {
            self.address?.source?.value = location//array  array [indexPath.row].location
            self.address?.source = self.address?.source // Temporary fix to call didSet
        }else {
            locationDetail = location
            self.address?.destination = location
            self.textFieldDestination.text = location?.address
            tableViewBottom.isHidden = true
        }
        
        if self.address?.source?.value != nil, self.address?.destination != nil {
            self.completion?(self.address!)
            self.backButtonAction()
        }
    }
    
    //automatic country code fetch
    func automaticCountryCodeFetch() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            let country = Common.getCountries()
            for eachCountry in country {
                if countryCode == eachCountry.code {
                    print(eachCountry.dial_code)
                    countryCodeTextFileld.text = eachCountry.dial_code
                }
            }
        }
    }
    
    // Mark : getting Current locations based on lat and lang
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.currentAddress = addressString
                }
        })
    }
    
    //get estimaterate based on source and destination locations
    
    func getEstimateFareFor() {
        var estimateFare = EstimateRequestModel()
        estimateFare.s_latitude = backGroundInstanse.userStoredDetail.latitude
        estimateFare.s_longitude = backGroundInstanse.userStoredDetail.lontitude
        estimateFare.d_latitude = locationDetail?.coordinate.latitude
        estimateFare.d_longitude = locationDetail?.coordinate.longitude
        estimateFare.service_type = User.main.serviceId
        
        self.presenter?.get(api: .estimateFare, parameters: estimateFare.JSONRepresentation)
    }
}

// MARK:- UITableViewDataSource

extension LocationSelectionView {
    
    @IBAction func DoneBtnAction(_ sender: UIButton) {
        
        guard let firstName = self.textFieldSource.text, !firstName.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterPhoneNumber, duration: 1.0, position: .center)
            return
        }
        
        guard let destination = self.textFieldDestination.text, !destination.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterDestination, duration: 1.0, position: .center)
            return
        }
        
        self.getEstimateFareFor()
    }
    
    @objc func backButtonAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewBottom.frame.origin.y = self.tableViewBottom.frame.height
            self.viewTop.frame.origin.y = -self.viewTop.frame.height
        }) { (_) in
            self.isHidden = true
            self.removeFromSuperview()
            self.onClickInstantRideBackBtn?(true)
        }
    }
    
    @objc func QRCodeTapped() {
        if let QRCodeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.QRCodeScanViewController) as? QRCodeScanViewController {
            QRCodeVC.QRScanCompletion = { (dialCode, dialNumber) in
                let qrCode = dialCode.replacingOccurrences(of: "tel:", with: "+")
                print(qrCode)
                self.textFieldSource.text = dialNumber
                self.countryCodeTextFileld.text = qrCode
            }
            (superview?.next as? UIViewController)?.navigationController?.pushViewController(QRCodeVC, animated: false)
        }
    }
}

// MARK:- UITableViewDataSource

extension LocationSelectionView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCell(for: indexPath)
    }
    
    //Get Table View Cell
    private func getCell(for indexPath : IndexPath)->UITableViewCell {
        
        // Predications
        
        if let tableCell = self.tableViewBottom.dequeueReusableCell(withIdentifier: XIB.Names.LocationTableViewCell, for: indexPath) as? LocationTableViewCell, datasource.count>indexPath.row{
            tableCell.imageLocationPin.image = #imageLiteral(resourceName: "ic_location_pin")
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(datasource[indexPath.row].placeID, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    let formatAddress = place.formattedAddress
                    let addressName = place.name
                    let formatAddressString = formatAddress!.replacingOccurrences(of: "\(addressName ?? ""), ", with: "", options: .literal, range: nil)
                    tableCell.lblLocationTitle.text = addressName
                    tableCell.lblLocationSubTitle.text = formatAddressString
                }
            })
            Common.setFont(to: tableCell.lblLocationTitle!)
            Common.setFont(to: tableCell.lblLocationSubTitle!)
            return tableCell
        }
        
        return UITableViewCell()
    }
}

// MARK:- UITableViewDelegate

extension LocationSelectionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.select(at: indexPath)
        self.textFieldDestination.resignFirstResponder()
    }
    
    //Did Select at Indexpath
    
    private func select(at indexPath : IndexPath){
        
        self.autoFill(with: (datasource[indexPath.row].attributedFullText.string, LocationCoordinate(latitude: 0, longitude: 0)))
        
        let placeID = datasource[indexPath.row].placeID
        GMSPlacesClient.shared().lookUpPlaceID(placeID) { (place, error) in
            
            if error != nil {
                self.make(toast: error!.localizedDescription)
            }
            else if let addressString = place?.formattedAddress, let coordinate = place?.coordinate{
                self.autoFill(with: (addressString,coordinate))
            }
        }
    }
    
}

// MARK:- UITextFieldDelegate

extension LocationSelectionView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == textFieldDestination {
            self.tableViewBottom.isHidden = false
        }
        self.datasource = []
        self.getPredications(from: textField.text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.datasource = []
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text, !text.isEmpty, range.location>0 || range.length >= 1 else {
            self.datasource = []
            return true
        }
        let searchText = text+string
        self.getPredications(from: searchText)
        print(textField.text ?? "", "  ", string, "   ", range.location, "  ", range.length)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == countryCodeTextFileld {
            let countryListVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.CountryListController) as! CountryListController
            (superview?.next as? UIViewController)?.navigationController?.pushViewController(countryListVC, animated: false)
            countryListVC.searchCountryCode = { code in
                let country = Common.getCountries()
                for eachCountry in country {
                    if code == eachCountry.code {
                        self.countryCodeTextFileld.text = eachCountry.dial_code
                    }
                }
            }
            return false
        }
        return true
    }
}

// MARK:- PostViewProtocol

extension LocationSelectionView : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            if let viewController = UIApplication.topViewController() {
                showAlert(message: message, okHandler: nil, fromView: viewController)
            }
        }
    }
    
    func getEstimateFare(api: Base, data: EstimateFareModel?) {
        
        if self.estimatedAlert == nil, let estimatedAlert = Bundle.main.loadNibNamed(XIB.Names.InstantRideConfirmView, owner: self, options: [:])?.first as? InstantRideConfirmView {
            
            estimatedAlert.PickUpAddressLbl.text = currentAddress
            estimatedAlert.dropLocationAddressLbl.text = locationDetail?.address
            estimatedAlert.d_lat =  locationDetail?.coordinate.latitude
            estimatedAlert.d_lang =  locationDetail?.coordinate.longitude
            estimatedAlert.estimatedPriceLbl.text = "\(String(describing: (data?.estimated_fare)!))"
            estimatedAlert.PhoneNumberLbl.text = "\(countryCodeTextFileld.text!)\(textFieldSource.text!)"
            estimatedAlert.country_code = countryCodeTextFileld.text!
            estimatedAlert.mobile = textFieldSource.text!
            
            estimatedAlert.onClickConfirm = { _ in
                self.removeFromSuperview()
                DispatchQueue.main.async {
                  self.onClickInstantRideBackBtn?(true)
                }
            }
            
            self.addSubview(estimatedAlert)
            if UIApplication.shared.keyWindow?.frame.width == 320 {
                estimatedAlert.frame = CGRect(x: 10 , y: self.viewTop.frame.height + 5, width: self.viewTop.frame.width-20, height:  350)
            }else{
                estimatedAlert.frame = CGRect(x: 10 , y: self.viewTop.frame.height + 5, width: self.viewTop.frame.width-20, height:  (estimatedAlert.frame.height))
            }
        }
    }
}
