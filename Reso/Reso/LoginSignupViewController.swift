//
//  LoginSignupViewController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var LastNameLabel: UILabel!
    
    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var loginButtonOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        guard let email = emailTextField.text, password = passwordTextField.text else { return }
        
        UserController.authUser(email, password: password) { (user) in
            
            guard user != nil else {
                print("unable to auth user")
                return
            }
            
            let vc = PollListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        guard let firstName = firstNameTextField.text, lastName = lastNameTextField.text, email = emailTextField.text, password = passwordTextField.text else { return }

        UserController.createUser("\(firstName) \(lastName)", email: email, password: password) { (user) in
            guard user != nil else {
                
                print("unable to create User")
                return
            }
            let vc = PollListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
