//
//  SettingTableViewController.swift
//  User
//
//  Created by CSS on 03/08/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    @IBOutlet var settingTableview: UITableView!
    var selectedIndex = -1
    private var selectedLanguage : Language = .english {
        didSet{
            setLocalization(language: selectedLanguage)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SetNavigationcontroller()
        
        
        if let lang = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: lang) {
            selectedLanguage = language
        }
    }

    func SetNavigationcontroller(){
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
        }
        title = Constants.string.settings.localize().uppercased()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(SettingTableViewController.backBarButton(sender:)))
    }
    
    @objc func backBarButton(sender: UIButton){
        self.popOrDismiss(animation: true)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Language.allCases.count
        } else if section == 1 {
            return 1
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingPageCell", for: indexPath) as! settingPageCell
        cell.textLabel?.textAlignment = .left
        if indexPath.section == 0 {
            cell.textLabel?.text = Language.allCases[indexPath.row].title.localize()
            cell.accessoryType = selectedLanguage == Language.allCases[indexPath.row] ? .checkmark : .none
            Common.setFont(to: cell.textLabel!)
        } else if indexPath.section == 1 {
            Common.setFont(to: cell.textLabel!)
            cell.textLabel?.text = Constants.string.documents.localize()
        }
         return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {  // Language Selection
            let language = Language.allCases[indexPath.row]
            var languageObject = LocalizationEntity()
            languageObject.language = language
            self.presenter?.post(api: .updateLanguage, data: languageObject.toData()) // Sending selected language to backend
            guard language != self.selectedLanguage else {return}
            self.selectedLanguage = language
            UserDefaults.standard.set(self.selectedLanguage.rawValue, forKey: Keys.list.language)
            self.tableView.reloadRows(at: (0..<Language.allCases.count).map({IndexPath(row: $0, section: 0)}), with: .automatic)
            selectedIndex = indexPath.row
            self.settingTableview.reloadData()
            self.switchSettingPage()
            
        } else if indexPath.section == 1 {  // Document Selection
            self.push(id: Storyboard.Ids.DocumentsTableViewController, animation: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {  // Language
            return Constants.string.Language.localize()
        } else {  // Documents
            return nil
        }
    }
    
    private func switchSettingPage() {
        self.navigationController?.isNavigationBarHidden = true // For Changing backbutton direction on RTL Changes
        guard let transitionView = self.navigationController?.view else {return}
        let settingVc = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.SettingTableViewController)
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationDuration(0.8)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
        self.navigationController?.pushViewController(settingVc, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        UIView.commitAnimations()
        if Int.removeNil(navigationController?.viewControllers.count) > 2 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
}

extension SettingTableViewController : PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
}

class settingPageCell : UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
