//
//  LandingPageViewController.swift
//  PotrioPass
//
//  Created by sarah oloumi on 2020-10-23.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//
import UIKit


import FirebaseAuth
import Firebase

class LandingPageViewController: UIViewController, UIAdaptivePresentationControllerDelegate, ModalTransitionListener {
    func popoverDismissed() {
        // reload the view here to update it
        // Remove all of the current accounts
        self.accounts.removeAll()
        self.accountListStackView.removeFullyAllArrangedSubviews()
        populateAccounts {
            self.setAccountButtons()
        }
    }
    
    @IBOutlet weak var accountListStackView: UIStackView!
    
    struct Cred {
        var accountUID: String
        var accountCreationDate: String
        var accountName: String
        var accountUsername: String
        var accountPassword: String
        var accountPermissions: String
    }
    
    // Create an array of user objects
    var accounts: [Cred] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModalTransitionMediator.instance.setListener(listener: self)
        populateAccounts {
            self.setAccountButtons()
        }
    }
    
    func populateAccounts( completion: @escaping ()-> Void) {

        let userData = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        
        userData.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                // Get account Names
                if ((dataDescription?["Accounts"]) != nil) {
                    // Accounts will the dictionary of account, accountvalue pairs we get
                    if let accounts = dataDescription?["Accounts"] as? [AnyHashable: Any] {
                        // For every account in accounts dictionary
                        for (key, value) in accounts {
                            let accountValue = value as! NSDictionary
                            // For every key in account
                            self.accounts.append(Cred(accountUID: key as! String ,accountCreationDate: accountValue["accountCreationDate"] as! String , accountName: accountValue["accountName"] as! String, accountUsername: accountValue["accountUsername"] as! String, accountPassword: accountValue["accountPassword"] as! String, accountPermissions: accountValue["accountPermissions"] as! String))
                        }
                    }
                }
                else {
                    
                }
            } else {
                print("Document does not exist")
            }
            completion()
        }
    }
    
    func setUpPasswordInfo() {
        
    }
    
    func setAccountButtons() {
       
        for account in accounts {
           
            let button = UIButton()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.setTitle(String(describing: account.accountName), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.7607843137, blue: 0.7607843137, alpha: 1), for: .normal)
            accountListStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        for account in accounts {
            if account.accountName == sender.titleLabel?.text {
                PortioPassVariables.accountCredentials.accountUID = account.accountUID
                PortioPassVariables.accountCredentials.accountName = account.accountName
                PortioPassVariables.accountCredentials.accountUsername = account.accountUsername
                PortioPassVariables.accountCredentials.accountPassword = account.accountPassword
                PortioPassVariables.accountCredentials.accountPermissions = account.accountPermissions
                PortioPassVariables.accountCredentials.accountCreationDate = account.accountCreationDate
            }
        }
        // Create new view controller obj
        let passwordUIViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.passwordUIViewControllerID) as! PasswordUserInterfaceViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(passwordUIViewController, animated: true)
    }
    
    
    @IBAction func onSignOutBtnTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        if self.storyboard != nil {
            let initPageViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.initPageViewControllerID) as! ViewController
            // Go to the other view controller
            self.navigationController?.pushViewController(initPageViewController, animated: true)
        }
    }
    
    @IBAction func onAddBtnTapped(_ sender: UIBarButtonItem) {
        // Create new view controller obj
        let addPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.addPasswordViewControllerID) as! AddPasswordViewController
        let navController = UINavigationController(rootViewController: addPasswordViewController)
        self.present(navController, animated:true, completion: nil)

    }
    
}
