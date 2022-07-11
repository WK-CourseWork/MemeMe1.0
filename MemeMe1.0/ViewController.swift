//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Waylon Kumpe on 7/11/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    #error("App Crashes on Share")
    #error("After selecting image, the bottom tool bar disappears so I can not change the image")
    #error("Text does not clear on first edit")
    #error("App does not comply with swift syntax. (See codacy for issues)")
    #error("Text background is not clear")
// MARK: - ImageView.
    @IBOutlet weak var imageView: UIImageView!
    var memedImage: UIImage!
    
    // MARK: TextFields.
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: ToolBars.
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    // MARK: Buttons.
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
  
    // MARK: - Take a new photo with the camera.
    @IBAction func cameraButtonAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Pick an image from the album.
    @IBAction func albumButtonAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
   
    // MARK: - View Did Load.
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
        // MARK: Hide NavBar.
        topToolBar.isHidden = true
        // MARK: Show ToolBar.
        bottomToolBar.isHidden = false
    }
    
    // MARK: View Will Appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    // MARK: View Will Dissappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Image Picker Controller.
    // For when you are finished picking which photo to use as a meme.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
            // MARK: Hide ToolBar.
            bottomToolBar.isHidden = true
            // MARK: Show NavBar.
            topToolBar.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Image Picker Controller Did Cancel.
    // For when you hit the cancel button.
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
       
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Will Show.
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // MARK: Get keyboard height.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Keyboard Will Hide.
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: - 0
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: TextField Did Begin Editing.
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
    }
    
    // MARK: TextField Should Return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    // MARK: - Meme Text Attributes.
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    // MARK: Subscribe to keyboard notifications.
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Unsubscribe to keyboard notifications.
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver (self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Save the meme.
    func save() {
        // Create the meme.
    let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    // MARK: Meme.
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
    }
    
    // MARK: - Generate the memed image.
    func generateMemedImage() -> UIImage {
        
        // MARK: Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // MARK: Share the meme.
    @IBAction func share(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(controller, animated: true, completion: nil)
    }
}
