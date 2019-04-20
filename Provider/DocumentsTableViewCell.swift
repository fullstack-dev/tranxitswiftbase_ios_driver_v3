//
//  DocumentsTableViewCell.swift
//  Provider
//
//  Created by CSS on 24/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {
    
    // MARK:- IBOutlet
    
    @IBOutlet private weak var imageViewPreview : UIImageView!
    @IBOutlet private weak var viewImagePreview : UIView!
    @IBOutlet weak var buttonAddEdit : UIButton!
    @IBOutlet private weak var buttonDelete : UIButton!
    
    private var id = 0
    var onclickAdd : (( _ id:Int,_ completion : @escaping((UIImage?)->()))->Void)?
    var onclickDelete : ((Int)->Void)?

    private var isImageAdded: Bool = false {
        didSet {
            self.buttonAddEdit.setTitle({
                return (isImageAdded ? Constants.string.edit : Constants.string.add).localize()
            }(), for: .normal)
            self.buttonDelete.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK:- LocalMethod
extension DocumentsTableViewCell {

    private func initialLoads() {
        self.isImageAdded = false
        self.localize()
        self.setDesign()
        self.buttonAddEdit.addTarget(self, action: #selector(self.buttonActionEditAdd), for: .touchUpInside)
    }
    
    private func setDesign() {
        Common.setFont(to: self.buttonDelete,isTitle: true)
        Common.setFont(to: self.buttonAddEdit,isTitle: true)
    }
    
    private func localize() {
        self.buttonDelete.setTitle(Constants.string.delete.localize(), for: .normal)
    }
    
    func set(values : DocumentsModel, modifiedDocuments documents : [Int:(image : UIImage, data : Data)]){
        if let docId = values.id, let imageObject = documents[docId] {
            self.imageViewPreview.image = imageObject.image
            self.isImageAdded = true
        } else {
            self.imageViewPreview.setImage(with: Common.getImageUrl(for: values.providerdocuments?.url), placeHolder: #imageLiteral(resourceName: "backgroundImage"))
            self.isImageAdded = values.providerdocuments != nil
        }
        self.id = values.id ?? 0
    }
}

// MARK:- IBAction

extension DocumentsTableViewCell {
    
    @objc func buttonActionEditAdd(sender: UIButton) {
        self.onclickAdd?(sender.tag, { image in
            
        })
    }
}

