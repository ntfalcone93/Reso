//
//  LoginSignupViewController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit


enum AccountType {
    case Existing
    case Create
}

class LoginSignupViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var imagePickerView: UIView!
    @IBOutlet weak var defaultProfileImage: UIImageView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectImageButtonOutlet: UIButton!
    
    var accountType: AccountType = .Existing
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBottomBorder(emailTextField)
        self.setBottomBorder(passwordTextField)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Last name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        
        defaultProfileImage.layer.shadowColor = UIColor.blackColor().CGColor
        defaultProfileImage.layer.shadowRadius = 3.0
        defaultProfileImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        defaultProfileImage.layer.shadowOpacity = 0.5
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setBottomBorder(firstNameTextField)
        self.setBottomBorder(lastNameTextField)
    }
    
    @IBAction func selectImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                alert.addAction(UIAlertAction(title: "Take Photo or Video", style: .Default, handler: { (_) in
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .Camera
                    imagePicker.cameraCaptureMode = .Photo
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }))
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        guard let email = emailTextField.text, password = passwordTextField.text where email.characters.contains("@") && password.characters.count >= 6 else { return self.loginAlert("Invalid Information", message: "Provide:\n-email\n-password (6 or more characters)") }
        setupActivityView()
        switch accountType {
        case .Existing:
            
            UserController.authUser(email, password: password, completion: { (user) in
                self.activityView.stopAnimating()
                guard user != nil else {
                    
                    self.loginAlert("Sorry", message: "Unable to access your account. Please try again.")
                    // TODO: Present an alert saying that we weren't able to login an account
                    return
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        case .Create:
            guard let firstName = firstNameTextField.text, lastName = lastNameTextField.text, image = defaultProfileImage.image else { return }
            
            if firstName == "" || lastName == "" {
                
                self.loginAlert("Invalid information", message: "Provide:\n- First name\n- Last name")
            }
            if selectImageButtonOutlet.selected == false  {
                activityView.stopAnimating()
                self.photoAlert("", message: "Would you like to add a new photo of yourself?")
            }
            else {
            
            UserController.createUser(firstName, lastName: lastName, image: image, email: email, password: password, completion: { (user) in
                self.activityView.stopAnimating()
                // TODO: Present an alert saying that we weren't able to create an account
                guard user != nil else {
                    self.loginAlert("Sorry", message: "The email address is already in use by another account")
                    return
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        }
    }
    
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        switch accountType {
        case .Existing:
            UIView.animateWithDuration(0.5, animations: {
                self.stackViewTopConstraint.constant = 20
                self.firstNameTextField.hidden = false
                self.lastNameTextField.hidden = false
                self.imagePickerView.hidden = false
                self.accountButton.setTitle("Already have an account?", forState: .Normal)
                self.loginButtonOutlet.setTitle("Create account", forState: .Normal)
            })
        case .Create:
            UIView.animateWithDuration(0.5, animations: {
                self.stackViewTopConstraint.constant = 85
                
                })
            UIView.animateWithDuration(0.5, animations: {
                self.setBottomBorder(self.firstNameTextField)
                self.setBottomBorder(self.lastNameTextField)
                self.firstNameTextField.hidden = true
                self.lastNameTextField.hidden = true
                self.imagePickerView.hidden = true
                self.accountButton.setTitle("Create an account?", forState: .Normal)
                self.loginButtonOutlet.setTitle("Login", forState: .Normal)
            })
        }
        accountType = accountType == .Existing ? .Create : .Existing
    }
    
    func photoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Default) { (okAction) in
            self.selectImageTapped()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (cancel) in
            self.selectImageButtonOutlet.selected = true
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(1.0) {
            self.stackViewTopConstraint.constant = 20
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        UIView.animateWithDuration(0.5) {
            if self.firstNameTextField.hidden == false {
                self.stackViewTopConstraint.constant  = 20
            } else {
            self.stackViewTopConstraint.constant = 85
            }
        }
        return true
    }
    
    func setupActivityView() {
        view.addSubview(activityView)
        activityView.center = view.center
        activityView.color = .blackColor()
        activityView.startAnimating()
    }
    
    func setBottomBorder(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
}

extension LoginSignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        selectImageButtonOutlet.selected = true
        defaultProfileImage.backgroundColor = UIColor.clearColor()
        defaultProfileImage.layer.borderWidth = 4.0
        defaultProfileImage.clipsToBounds = true
        defaultProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        defaultProfileImage.layer.cornerRadius = defaultProfileImage.frame.height/2
        defaultProfileImage.contentMode = UIViewContentMode.ScaleAspectFill
        defaultProfileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        selectImageButtonOutlet.selected = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

