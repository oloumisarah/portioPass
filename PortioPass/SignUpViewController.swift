//
//  SignUpViewController.swift
//  PortioPass
//
//  Created by sarah oloumi on 2020-10-23.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//

import UIKit

import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var PasswordConfirmationTextField: UITextField!
    
    @IBOutlet weak var SignUpBtnView: UIButton!
    @IBOutlet weak var BackBtnView: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyle()
       
    }
    
    /*
     Sets up the style of page
     */
    func setUpStyle() {
        
        FirstNameTextField.useUnderline()
        LastNameTextField.useUnderline()
        EmailTextField.useUnderline()
        PasswordTextField.useUnderline()
        PasswordConfirmationTextField.useUnderline()
        
        SignUpBtnView.layer.cornerRadius = 15
        SignUpBtnView.layer.borderWidth = 1
        SignUpBtnView.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
        BackBtnView.layer.cornerRadius = 15
        BackBtnView.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
        BackBtnView.layer.borderWidth = 1
        
        ErrorLabel.isHidden = true
    }
        
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        // Validate user input fields
        let validationResponse = validateUserInput()
        if validationResponse != nil {
            viewError(validationResponse!)
        }
        else {
            // Register new user with reference to https://firebase.google.com/docs/auth/ios/password-auth?authuser=0
            // A form is created which allows for new users to sign in using their email address and password.
            // When a form is completed, validate the email address and password provided by the user
            // userUID is stored in authDataResult
            Auth.auth().createUser(withEmail: EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   password: PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { [self] (authDataResult, error) in
                if error != nil {
                    self.viewError((error?.localizedDescription)!)
                }
                else {
                    // Store user data
                    let firestore = Firestore.firestore()
                    // Get information about the user
                    firestore.collection("users").document(authDataResult!.user.uid).setData( ["firstName":FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "lastName":LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "uid":authDataResult!.user.uid]) { (err) in
                        // In case there is something wrong, notify the user via error message because their firstname/lastname wasnt captured in the database
                        if error != nil {
                            // MUST: Implement a way to get user data again and save it .. for now user account was still created
                            viewError("User Data could not be saved.")
                        }
                    }
                    // Navigate to the Landing page
                    self.navigateToLandingPage()
                }
            }
        }
    }
    
    @IBAction func OnBackBtnViewTapped(_ sender: Any) {
        // Create new view controller obj
        let initPageViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.initPageViewControllerID) as! ViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(initPageViewController, animated: true)
    }

    // This function will check every field and ensure everything is correct.
    func validateUserInput() -> String? {
        
        // Validate that all fields are filled in
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordConfirmationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please ensure all fields are filled."
        }
        
        // Remove all white spaces from the password
        let userPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordGood(userPassword) == true {
            
            let userPasswordConfirmation = PasswordConfirmationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if (userPasswordConfirmation == userPassword) {
                return nil
            }
            else {
                return "Passwords don't match."
            }
        }
        else {
            // Password is weak, ask the user to enter their password again
            return "Your password must be at least 10 characters, contains a special character and a number."
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
    
    // This function will show the error to user when necessary.
    func viewError(_ message:String) {
        
        ErrorLabel.text = message
        ErrorLabel.isHidden = false
    }
    
    
}
