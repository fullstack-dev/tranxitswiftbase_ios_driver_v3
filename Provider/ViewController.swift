
import UIKit
import Foundation

//MARK:- LocalVariable

fileprivate var bottomConstraint : NSLayoutConstraint?
fileprivate var imageCompletion : ((UIImage?)->())?
fileprivate var constraintValue : CGFloat = 0

extension UIViewController {
    
    func setPresenter(){
        
        if let view = self as? PostViewProtocol {
            
            view.presenter = presenterObject
            view.presenter?.controller = view
            presenterObject = view.presenter
            
        }
    }
    
    // Pop or dismiss View Controller
    
    func popOrDismiss(animation : Bool){
        
        DispatchQueue.main.async {
            
            if self.navigationController != nil {
                
                self.navigationController?.popViewController(animated: animation)
            } else {
                
                self.dismiss(animated: animation, completion: nil)
            }
            
        }
        
    }
    
    //Present
    
    func present(id : String, animation : Bool, from storyboard : UIStoryboard = Router.main){
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        self.present(vc, animated: animation, completion: nil)
    }
    
    //Push
    func push(id : String, animation : Bool, from storyboard : UIStoryboard = Router.main){
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    
    //Push To Right
    func pushRight(toViewController viewController : UIViewController){
        
        self.makePush(transition: convertFromCATransitionSubtype(CATransitionSubtype.fromLeft))
        navigationController?.pushViewController(viewController, animated: false)
        
    }
    
    private func makePush(transition type : String){
        
        let transition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = convertToOptionalCATransitionSubtype(type)
        navigationController?.view.layer.add(transition, forKey: nil)
    }
    
    func popLeft() {
        
        self.makePush(transition: convertFromCATransitionSubtype(CATransitionSubtype.fromRight))
        navigationController?.popViewController(animated: true)
        
    }
    
    //Add observers
    func addKeyBoardObserver(with constraint : NSLayoutConstraint){
        
        bottomConstraint = constraint
        constraintValue = constraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(info:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(info:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(info:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

extension UIViewController {
    
    
    //Keyboard will show
    
    @objc func keyboardWillShow(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        bottomConstraint?.constant = -(keyboard.height)
        self.view.layoutIfNeeded()
    }
    
    //Keyboard will hide
    
    @objc func keyboardWillHide(info : NSNotification){
        
        bottomConstraint?.constant = constraintValue
        self.view.layoutIfNeeded()
    }
    
    //Back Button Action
    @objc func backButtonClick() {
        //BackGroundTask.backGroundInstance.detailviewStatus = false
        self.popOrDismiss(animation: true)
        
    }

    //Show Image Selection Action Sheet
    func showImage(with completion : @escaping ((UIImage?)->())){
        
        let alert = UIAlertController(title: Constants.string.selectSource.localize(), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.string.camera.localize(), style: .default, handler: { (Void) in
            self.chooseImage(with: .camera)
        }))
        alert.addAction(UIAlertAction(title: Constants.string.photoLibrary.localize(), style: .default, handler: { (Void) in
            self.chooseImage(with: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler:nil))
        alert.view.tintColor = .primary
        imageCompletion = completion
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Show Image Picker
    private func chooseImage(with source : UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Show Search Bar with self delegation
    @IBAction private func showSearchBar(){
        
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.delegate = self as? UISearchBarDelegate
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        searchBar.searchBar.tintColor = .primary
        self.present(searchBar, animated: true, completion: nil)
        
    }
}

//MARK:- UIImagePickerControllerDelegate

extension UIViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        picker.dismiss(animated: true) {
            if let image = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                imageCompletion?(image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
        return input.rawValue
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
        guard let input = input else { return nil }
        return CATransitionSubtype(rawValue: input)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

//MARK:- UINavigationControllerDelegate

extension UIViewController: UINavigationControllerDelegate {
    
}






