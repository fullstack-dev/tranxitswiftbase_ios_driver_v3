//
//  RatingView.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    //MARK:- IBOutlet

    @IBOutlet  weak var labelRating:UILabel!
    @IBOutlet  weak var imageViewProvider : UIImageView!
    @IBOutlet  weak var viewRating : FloatRatingView!
    @IBOutlet  weak var textViewComments : UITextView!
    @IBOutlet  weak var buttonSubmit : UIButton!
    
    //MARK:- LocalVariable

    var onclickRating : ((_ rating : Int,_ comments : String)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialLoads()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageViewProvider.makeRoundedCorner()
    }
}

//MARK:- LocalMethod

extension RatingView {
    
    func initialLoads() {
        
        self.textViewComments.delegate = self
        textViewDidEndEditing(textViewComments)
        self.localize()
        self.buttonSubmit.addTarget(self, action: #selector(self.buttonActionRating), for: .touchUpInside)
        self.viewRating.minRating = 1
        self.viewRating.maxRating = 5
        self.viewRating.rating = 1
        self.viewRating.emptyImage = #imageLiteral(resourceName: "StarEmpty")
        self.viewRating.fullImage = #imageLiteral(resourceName: "StarFull")
        self.setDesign()
    }
    
    private func setDesign() {
        
        setFont(TextField: nil, label: labelRating, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonSubmit, size: nil)
        
    }
    
    private func localize() {
        
        self.labelRating.text = Constants.string.rateyourtrip.localize()
        self.buttonSubmit.setTitle(Constants.string.submit.localize(), for: .normal)
    }
}

//MARK:- IBAction

extension RatingView {
    
    @objc func buttonActionRating() {
        self.onclickRating?(Int(viewRating.rating), textViewComments.text)
    }
}

//MARK:- UITextViewDelegate

extension RatingView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == Constants.string.writeYourComments.localize() {
            textView.text = .Empty
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == .Empty {
            textView.text = Constants.string.writeYourComments.localize()
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
