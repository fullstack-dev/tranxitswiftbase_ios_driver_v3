//
//  WalkThroughPreviewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalkThroughPreviewController: UIViewController {
    
    @IBOutlet private weak var imageView : UIImageView!
    @IBOutlet private weak var labelTitle : UILabel!
    @IBOutlet private weak var labelSubTitle : UILabel!
    
    private var arrayData : (UIImage?,String?,String?)?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialLoads()
    }

}

//MARK:- Methods

extension WalkThroughPreviewController {
    
    private func intialLoads(){
        
        self.labelTitle.textColor = .primary
        self.imageView.image = arrayData?.0
        self.labelTitle.text = arrayData?.1?.localize()
        self.labelSubTitle.text = arrayData?.2?.localize()
        self.desgin()
        self.setCommonFont()
        
    }
    
    func set(image : UIImage?, title : String?, description descriptionText : String?){
        
       self.arrayData = (image,title,descriptionText)
        
    }
    
    
    private func desgin(){
        
        self.labelTitle.font = UIFont(name: FontCustom.medium.rawValue, size: 30)
        self.labelSubTitle.font = UIFont(name: FontCustom.medium.rawValue, size: 12)
        
    }
    
    private func setCommonFont(){
        
        setFont(TextField: nil, label: labelTitle, Button: nil, size: nil, with: true)
        setFont(TextField: nil, label: labelSubTitle, Button: nil, size: nil)
    }
    
}
