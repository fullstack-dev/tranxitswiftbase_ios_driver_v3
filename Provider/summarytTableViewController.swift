//
//  summarytTableViewController.swift
//  User
//
//  Created by CSS on 11/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class summarytTableViewController: UITableViewController {
    
    //MARK:- IBOutlet
    @IBOutlet var viewRevenue: UIView!
    @IBOutlet var viewRides: UIView!
    @IBOutlet var viewShuduledRide: UIView!
    @IBOutlet var viewCancleRides: UIView!
    @IBOutlet var labelRevenue: UILabel!
    @IBOutlet var labelshuduled: UILabel!
    @IBOutlet var labelCancelRide: UILabel!
    @IBOutlet var labelTotalRides: UILabel!
    @IBOutlet var labelTotalRideValue: UILabel!
    @IBOutlet var labelRivenueValue: UILabel!
    @IBOutlet var labelShueduleRideValue: UILabel!
    @IBOutlet var labelCancelRideValue: UILabel!
    @IBOutlet var revenue: [UILabel]!
    
    //MARK:- Variable

    let aniamtionDuration: Double = 1.5
    var startValue: Int = 0
    let endValue: Int = 20
    var rideEndValue : Int = 0
    var revenueEndValue : String?
    var scheduleRideEndValue : Int = 0
    var cancelledRideEndValue : Int = 0
    var summaryValue : SummaryModelResponse?
    var displayLink = CADisplayLink()
   let animationStartDate = Date()
    let animationDuration: Double = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        SetNavigationcontroller()
        setCommonFont()
        loadAPI()
        self.localize()
    }
}

//MARK:- Method

extension summarytTableViewController {
    
    private func loadAPI(){
        self.presenter?.post(api: .summary, data: nil)
    }
    
    private func addShadow() {
        
        self.viewRides = shadowApply(view: self.viewRides)
        self.viewRevenue = shadowApply(view: self.viewRevenue)
        self.viewShuduledRide = shadowApply(view: self.viewShuduledRide)
        self.viewCancleRides = shadowApply(view: self.viewCancleRides)
    }
    
    private func addDisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAnimation))
        displayLink.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    private func setValue(Value: SummaryModelResponse?) {
        
        rideEndValue = Value?.rides ?? 0
        revenueEndValue = "\(Value?.revenue ?? 0)"
        scheduleRideEndValue = Value?.scheduled_rides ?? 0
        cancelledRideEndValue = Value?.cancel_rides ?? 0
        addDisplayLink()
    }
    
    private func setCommonFont() {
        
        setFont(TextField: nil, label: labelCancelRide , Button: nil, size: nil)
        setFont(TextField: nil, label: labelTotalRideValue, Button: nil, size: 25)
        setFont(TextField: nil, label: labelshuduled, Button: nil, size: nil)
        setFont(TextField: nil, label: labelRevenue, Button: nil, size: nil)
        setFont(TextField: nil, label: labelTotalRideValue, Button: nil, size: 25)
        setFont(TextField: nil, label: labelRivenueValue, Button: nil, size: 25)
        setFont(TextField: nil, label: labelCancelRideValue, Button: nil, size: 25)
        setFont(TextField: nil, label: labelShueduleRideValue, Button: nil, size: 25)
    }
    
    private func localize() {
        
        self.labelRevenue.text = Constants.string.revenue.localize()
        self.labelshuduled.text = Constants.string.schueduleRides.localize()
        self.labelTotalRides.text = Constants.string.totalNoOfRides.localize()
        self.labelCancelRide.text = Constants.string.cancelRides.localize()
    }
    
    func SetNavigationcontroller() {
        
        if #available(iOS 11.0, *) {
            self.navigationController?.isNavigationBarHidden = false
            //self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title =  Constants.string.summary.localize()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(summarytTableViewController.backBarButtonTapped(sender:)))
    }
    
}

//MARK:- IBAction

extension summarytTableViewController {
    
    @objc func displayLinkAnimation() {
        
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            self.labelRivenueValue.text = revenueEndValue
            self.labelTotalRideValue.text = "\(rideEndValue)"
            self.labelCancelRideValue.text = "\(cancelledRideEndValue)"
            self.labelShueduleRideValue.text = "\(scheduleRideEndValue)"
        }
        else{
            self.labelRivenueValue.text = "\(startValue)"
            self.labelTotalRideValue.text = "\(startValue)"
            self.labelCancelRideValue.text = "\(startValue)"
            self.labelShueduleRideValue.text = "\(startValue)"
            self.startValue += 1
        }
        
        if startValue > rideEndValue{
            self.labelTotalRideValue.text = "\(rideEndValue)"
        }
        
        if revenueEndValue != nil {
            self.labelRivenueValue.text = "\(User.main.currency ?? "") \(revenueEndValue!)"
        }
        
        if startValue > scheduleRideEndValue {
            self.labelShueduleRideValue.text = "\(scheduleRideEndValue)"
        }
        
        if startValue > cancelledRideEndValue  {
            self.labelCancelRideValue.text = "\(cancelledRideEndValue)"
        }
    }
    
    @objc private func backBarButtonTapped(sender: UIButton){
        self.popOrDismiss(animation: true)
        
    }
}

//MARK:- TableView

extension summarytTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height/4.5
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.addShadow()
    }
}

//MARK:- PostViewProtocol

extension summarytTableViewController: PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getSummary(api: Base, data: SummaryModelResponse?) {
        
        self.summaryValue = data
        self.setValue(Value: data)
    }
}
