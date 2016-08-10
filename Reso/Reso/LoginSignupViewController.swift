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

class LoginSignupViewController: NSObject, UIViewController, UITextFieldDelegate //,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
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
    
    var accountType: AccountType = .Existing
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        emailTextField.layer.borderColor = UIColor.whiteColor().CGColor
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        passwordTextField.layer.borderColor = UIColor.whiteColor().CGColor
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        firstNameTextField.layer.borderColor = UIColor.whiteColor().CGColor
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Last name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        lastNameTextField.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        defaultProfileImage.layer.shadowColor = UIColor.blackColor().CGColor
        defaultProfileImage.layer.shadowRadius = 3.0
        defaultProfileImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        defaultProfileImage.layer.shadowOpacity = 0.5
        
    }
    
    @IBAction func selectImageTapped(sender: AnyObject) {
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
    
    
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        let presentationAnimator = TransitionPresentationAimator()
//        return presentationAnimator
//        
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        let dismissalAnimator = TransitionDismissalAnimator()
//        return dismissalAnimator
//        
//    }
//    
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 0.5
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let containerView = transitionContext.containerView()
//        
//        let animationDuration = self .transitionDuration(transitionContext)
//        
//        // take a snapshot of the detail ViewController so we can do whatever with it (cause it's only a view), and don't have to care about breaking constraints
//        let snapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
//        snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
//        snapshotView.center = fromViewController.view.center
//        containerView.addSubview(snapshotView)
//        
//        // hide the detail view until the snapshot is being animated
//        toViewController.view.alpha = 0.0
//        containerView.addSubview(toViewController.view)
//        
//        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: [],
//                                   animations: { () -> Void in
//                                    snapshotView.transform = CGAffineTransformIdentity
//            }, completion: { (finished) -> Void in
//                snapshotView.removeFromSuperview()
//                toViewController.view.alpha = 1.0
//                transitionContext.completeTransition(finished)
//        })
//    }
//        
//    }
    
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        guard let email = emailTextField.text, password = passwordTextField.text where email.characters.contains("@") && password.characters.count >= 6 else { return self.loginAlert("Invalid Information", message: "Provide:\n-email\n-password (6 or more characters)") }
        setupActivityView()
        switch accountType {
        case .Existing:
            
            UserController.authUser(email, password: password, completion: { (user) in
                self.activityView.stopAnimating()
                guard user != nil else {
                    
                    self.loginAlert("Sorry", message: "Unable to access your account at this time. Please try again.")
                    // TODO: Present an alert saying that we weren't able to login an account
                    return
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        case .Create:
            guard let firstName = firstNameTextField.text, lastName = lastNameTextField.text, image = defaultProfileImage.image else { return }
            print("\(defaultProfileImage.image)")
            
            if firstName == "" || lastName == "" {
                self.loginAlert("Invalid information", message: "Provide:\n- First name\n- Last name")
            }
            
            if image.images == UIImage(named: "defaultProfileImage") {
                self.photoAlert("", message: "Would you like to add a new photo of yourself?")
            }
            
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
    
    func photoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Default) { (okAction) in
            self.selectImageTapped(self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
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
            self.stackViewTopConstraint.constant = 85
        }
        return true
    }
    
    func setupActivityView() {
        view.addSubview(activityView)
        activityView.center = view.center
        activityView.color = .blackColor()
        activityView.startAnimating()
    }
    
    
}

extension LoginSignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defaultProfileImage.layer.borderWidth = 4.0
        defaultProfileImage.clipsToBounds = true
        defaultProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        defaultProfileImage.layer.cornerRadius = defaultProfileImage.frame.height/2
        defaultProfileImage.contentMode = UIViewContentMode.ScaleAspectFill
        defaultProfileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("user cancelled image")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
