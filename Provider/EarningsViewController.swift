//
//  EarningsViewController.swift
//  User
//
//  Created by CSS on 11/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class EarningsViewController: UITableViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet var tableViewEarnings: UITableView!
    
    //MARK:- Variable
    
    var headerView : headerView?
    var headerArray : [ridesArray]?
    var ridesCompletedCount: Double?
    var Grandtotal = [AnyHashable: Float]()
    var backGoriundImageView = UIImageView()
    let backgroundImage = UIImage(named: "Your earnings did no")
    var totaEarnings: Float = 0.0
    
    lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadAPI()
        setBackFroundImageForTableView()
        self.backGoriundImageView.isHidden = true
        SetNavigationcontroller()
        self.headerView = Bundle.main.loadNibNamed(XIB.Names.headerView, owner: self, options: nil)?.first as? headerView
        self.headerView?.frame = CGRect(x: 0, y: 0, width: 357, height: 380)
        tableViewEarnings.tableHeaderView = self.headerView
    }
}

//MARK:- Method

extension EarningsViewController {
    
    func setValueForTarget(){
        let layer = setCircleAnimation(view: self.headerView!, toVlaue: Float(ridesCompletedCount!))
        self.headerView?.layer.insertSublayer(layer, below: self.headerView?.countLabel.layer)
        self.headerView?.bringSubviewToFront((self.headerView?.countLabel)!)
        let total = self.headerArray?.reduce(into: 0, { (res, arr) in return res = res+Float.removeNil(arr.payment?.provider_pay)})
        self.headerView?.labelMoney.text = " \(User.main.currency ??  "") \(Formatter.shared.limit(string: "\(Float.removeNil(total))", maximumDecimal: 2))"
    }
    
    private func setBackFroundImageForTableView(){
        
        backGoriundImageView = UIImageView(image: backgroundImage)
        backGoriundImageView.contentMode = .scaleAspectFit
        self.backGoriundImageView.frame.origin.y = 500
        self.tableViewEarnings.backgroundView = backGoriundImageView
        self.tableViewEarnings.addSubview(self.backGoriundImageView)
    }
    
    private func loadAPI() {
        
        self.loader.isHidden = false
        self.presenter?.get(api: .earnings, parameters: nil)
    }
    
    func registerHeaderCell(){
        tableViewEarnings.register(UINib(nibName: XIB.Names.headerTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.headerTableViewCell)
    }
    
    func SetNavigationcontroller(){
        if #available(iOS 11.0, *) {
            // self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.isNavigationBarHidden = false
        }
        else {
            // Fallback on earlier versions
        }
        title = Constants.string.Earnings.localize()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(EarningsViewController.backBarbuttonAction(button:)))
    }
}

//MARK:- IBAction

extension EarningsViewController {
    
    @objc private func backBarbuttonAction(button: UIButton){
        self.popOrDismiss(animation: true)
    }
}

//MARK:- Tableview

extension EarningsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int.removeNil(headerArray?.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.earningCell) as! earningCell
        let date = Formatter.shared.getDate(from: self.headerArray?[indexPath.row].finished_at, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss)
        let dateString = Formatter.shared.getString(from: date, format: DateFormat.list.hhMMTTA)
        
        cell.labelTime.text = dateString
        cell.labelKm.text = "\((self.headerArray?[indexPath.row].distance ?? 0)) km"
        cell.labelTotal.text = " \(User.main.currency ??  "") \(self.headerArray?[indexPath.row].payment?.provider_pay ?? 0 )"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = Bundle.main.loadNibNamed(XIB.Names.sectionView, owner: self, options: nil)?.first as? sectionView
        customView?.frame = CGRect(x: 0, y: 0, width: 357, height: 64)
        return customView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.00
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK:- PostViewProtocol

extension EarningsViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getEarningsAPI(api: Base, data: EarnigsModel?) {
        self.loader.isHidden = true
        self.headerView?.countLabel.text = "\(data?.rides_count ?? 0)/\(data?.target ?? "0")"
        
        if data?.rides?.count == 0 {
            //self.backGoriundImageView.isHidden = false
            self.ridesCompletedCount = 0
            self.setValueForTarget()
            
        }else{
            self.headerArray = data?.rides
            // let targetCount = Int(data?.target ?? "")
            let count = Double(data?.rides_count ?? 0) /  10
            self.ridesCompletedCount = count
            self.setValueForTarget()
            self.tableViewEarnings.reloadData()
        }
    }
}

//MARK:- UITableViewCell

class earningCell: UITableViewCell {
    
    @IBOutlet var labelTotal: UILabel!
    @IBOutlet var labelKm: UILabel!
    @IBOutlet var labelTime: UILabel!
    
    override func awakeFromNib() {
        
    }
}






