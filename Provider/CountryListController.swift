//
//  CountryListController.swift

//
//  Created by User on 12/06/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class CountryListController: UIViewController {
    
    // MARK:- IBOutlet

    @IBOutlet weak var countryListTbl:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    // MARK:- Varaiable

    var searchActive = false
    var FromSignUpPage = false
    
    var filterNameArr: NSMutableArray = []
    var filterCodeArr: NSMutableArray = []
    var filterImageArr: NSMutableArray = []
    var countryNameArr: NSMutableArray = []
    var countryCodeArr: NSMutableArray = []
    var countryKeyCodeArr: NSMutableArray = []
    
    var searchCountryCode : ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCountryList()
        searchBar.showsCancelButton = false
    }
    
    func getCountryList() {
        let countryList = Common.getCountries()
        for eachCountry in countryList {
            countryNameArr.add(eachCountry.name)
            countryCodeArr.add(eachCountry.dial_code)
            countryKeyCodeArr.add(eachCountry.code)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapClose(_ sender:UIButton) {
        if FromSignUpPage == true {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: false)
        }
    }
}

//MARK:- UITableViewDataSource

extension CountryListController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return filterNameArr.count
        }
        else{
            return countryCodeArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CountryListCell = self.countryListTbl.dequeueReusableCell(withIdentifier: "CountryListCell", for: indexPath) as! CountryListCell
        let name = searchActive ? filterNameArr[indexPath.row] : countryNameArr[indexPath.row]
        let code = searchActive ? filterCodeArr[indexPath.row] : countryCodeArr[indexPath.row]
        let flag = searchActive ? filterImageArr[indexPath.row] : countryKeyCodeArr[indexPath.row]
        
        cell.countryNameLbl.text = name as? String
        cell.codeLbl.text = "\(code as! String)"
        cell.flagImage.image = UIImage(named: "CountryPicker.bundle/\(flag).png")
        return cell
    }
}

//MARK:- UITableViewDelegate

extension CountryListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let code = searchActive ? filterImageArr[indexPath.row] : countryKeyCodeArr[indexPath.row]
        self.searchCountryCode?(code as! String)
        
        self.countryCodeArr.removeAllObjects()
        self.countryNameArr.removeAllObjects()
        self.countryKeyCodeArr.removeAllObjects()
        DispatchQueue.main.async {
            if self.FromSignUpPage == true {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK:- UISearchBarDelegates

extension CountryListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterCodeArr.removeAllObjects()
        self.filterNameArr.removeAllObjects()
        self.filterImageArr.removeAllObjects()
        print(searchText)
        
        if searchText.count == 0 {
            searchActive = false
            self.countryListTbl.reloadData()
        }
        else{
            searchActive = true
            let filter = countryNameArr.filter({ (text) -> Bool in
                let tmp:NSString = text as! NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            for i in 0..<countryNameArr.count {
                for j in 0..<filter.count {
                    let test = filter[j] as! String
                    if test == countryNameArr[i] as! String{
                        self.filterCodeArr.add(countryCodeArr[i])
                        self.filterNameArr.add(countryNameArr[i])
                        self.filterImageArr.add(countryKeyCodeArr[i])
                    }
                }
            }
            print(filter)
        }
        self.countryListTbl.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        searchActive = true
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
}
