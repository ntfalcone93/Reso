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

class LoginSignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var imagePickerView: UIView!
    
    var accountType: AccountType = .Existing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImageTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        guard let email = emailTextField.text, password = passwordTextField.text else { return }
        switch accountType {
        case .Existing:
            UserController.authUser(email, password: password, completion: { (user) in
                guard user != nil else {
                    // TODO: Present an alert saying that we weren't able to login an account
                    return
                }
            })
        case .Create:
            guard let firstName = firstNameTextField.text, lastName = lastNameTextField.text else { return }
            UserController.createUser(firstName, lastName: lastName, photoUrl: "", email: email, password: password, completion: { (user) in
                    // TODO: Present an alert saying that we weren't able to create an account
                guard user != nil else {
                    return
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        switch accountType {
        case .Existing:
            UIView.animateWithDuration(0.3, animations: {
                self.firstNameTextField.hidden = false
                self.lastNameTextField.hidden = false
                self.imagePickerView.hidden = false
                self.accountButton.setTitle("Already have an account?", forState: .Normal)
                self.loginButtonOutlet.setTitle("Create account", forState: .Normal)
            })
        case .Create:
            UIView.animateWithDuration(0.3, animations: {
                self.firstNameTextField.hidden = true
                self.lastNameTextField.hidden = true
                self.imagePickerView.hidden = true
                self.accountButton.setTitle("Create an account?", forState: .Normal)
                self.loginButtonOutlet.setTitle("Login", forState: .Normal)
            })
        }
        accountType = accountType == .Existing ? .Create : .Existing
    }
}

extension LoginSignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        guard let data = UIImageJPEGRepresentation(image, 0.8) else {
//            return
//        }
//        let storageRef = FIRStorage.storage().reference()
//        
//        let userImageRef = storageRef.child("users/image.jpg")
//        
//        userImageRef.putData(data, metadata: nil) { (metadata, error) in
//            guard error == nil else {
//                print(error?.localizedDescription)
//                return
//            }
//            guard let metadata = metadata else {
//                return
//            }
//            self.userPhotoUrl = metadata.downloadURL()?.absoluteString
//        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
