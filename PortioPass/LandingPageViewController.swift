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

class LandingPageViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    
    // Create an array of user objects
    var accounts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
                    if let accounts = dataDescription?["Accounts"] as? [AnyHashable: Any] {
                        for (key,_) in accounts {
                            self.accounts.append( key as! String)
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
            button.setTitle(String(describing: account), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.7607843137, blue: 0.7607843137, alpha: 1), for: .normal)
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton){
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
