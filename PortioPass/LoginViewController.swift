//
//  LoginViewController.swift
//  PotrioPass
//
//  Created by sarah oloumi on 2020-10-23.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//

import UIKit

import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var LoginBtnView: UIButton!
    @IBOutlet weak var BackBtnView: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        setUpStyle()
    }
    
    /*
     Sets up the style of page
     */
    func setUpStyle() {
        
        EmailTextField.useUnderline()
        PasswordTextField.useUnderline()
        
        LoginBtnView.layer.cornerRadius = 15
        LoginBtnView.layer.borderWidth = 1
        LoginBtnView.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
        BackBtnView.layer.cornerRadius = 15
        BackBtnView.layer.borderWidth = 1
        BackBtnView.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
        
        ErrorLabel.isHidden = true
    }
    
    @IBAction func onBackBtnViewTapped(_ sender: Any) {
        // Create new view controller obj
        let initPageViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.initPageViewControllerID) as! ViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(initPageViewController, animated: true)
    }
    @IBAction func onLoginBtnViewTapped(_ sender: Any) {
        // Validate user input
        validateUserInput()
        // Login user
        Auth.auth().signIn(withEmail: EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (authenticationResult, error) in
            
            if error != nil {
                // trouble signing in due to bad password/email pair
                self.ErrorLabel.text = error!.localizedDescription
                self.ErrorLabel.isHidden = false
            }
            else {
                self.navigateToLandingPage()
                
            }
        }
    }
    // This function will check every field and ensure everything is correct.
    func validateUserInput() -> String? {
        
        // Validate that all fields are filled in
        if  EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please ensure ensure entered an email and password"
        }
        return nil
    }
    // Navigate to landing page view screen controller
    func navigateToLandingPage() {
        // Create new view controller obj
        let landingPageViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.landingPageViewControllerID) as! LandingPageViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(landingPageViewController, animated: true)
            
    }
}

