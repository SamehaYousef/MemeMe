//
//  MemeMeViewController.swift
//  Meme1
//
//  Created by Sameha Yousef on 02/02/1441 AH.
//  Copyright © 1441 Sameha Yousef. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Creates the properties of the textfields
        
        setTextFields(textInput: topTextField, defaultText: "TOP")
        setTextFields(textInput: bottomTextField, defaultText: "BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        shareButton.isEnabled = viewImage.image != nil
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //Checks to see whether the specified source type is available within the device
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    func controllerSourceType(type: UIImagePickerController.SourceType){
       
        let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Choose photo from Album
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        controllerSourceType(type: .photoLibrary)
        
    }
    
    // MARK: Choose photo from Camera
    
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        controllerSourceType(type: .camera)
       }
    
    
    //if an image was chosen from the album...
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            viewImage.image = image
            shareButton.isEnabled = viewImage.image != nil
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //no image was chosen
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setTextFields(textInput: UITextField, defaultText: String){
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -4.0
        ]
        textInput.text = defaultText
        textInput.defaultTextAttributes = memeTextAttributes
        textInput.delegate = self
        textInput.textAlignment = .center
        
    }
    
    //Allows editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        if(textField == topTextField || textField == bottomTextField) && (text == "TOP" || text == "BOTTOM"){
            textField.text = ""
        }
    }
    //if no change was made to "TOP" & "BOTTOM"...
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmpty = textField.text?.isEmpty ?? true
        if isEmpty && textField == topTextField{
            topTextField.text = "TOP"
        } else if isEmpty && textField == bottomTextField{
            bottomTextField.text = "BOTTOM"
        }
             }
    
    
    // MARK: Notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
       if bottomTextField.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
       }
    }
    
    @objc func keyboardWillHide(_notification:Notification) -> Void {
           view.frame.origin.y = 0
           
       }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
   
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func hide(hide:Bool){
        bottomToolBar.isHidden = hide
        navigationController!.navigationBar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        
        hide(hide: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hide(hide: false)
        
        return memedImage
    }
    
    
    // MarK: MEME Object
    
    func save() {
        
        // Create the meme
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: viewImage.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            
            if success{
                self.save()
            }
            
        }
        //for app to work on iPads
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.barButtonItem = shareButton
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
  

    @IBAction func cancelButton (_sender: AnyObject) {
        
       // navigationController?.popToRootViewController(animated: true)
        print("cancel")
        //return to initail view controller
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        

            
           }
       
    
}

