//  PasswordUserInterfaceViewController.swift
//  PotrioPass
//
//  Created by sarah oloumi on 2020-10-23.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//

import UIKit

import FirebaseAuth
import Firebase

class PasswordUserInterfaceViewController: UIViewController {
    
    
    @IBOutlet weak var websiteNameLabel: UILabel!
    @IBOutlet weak var userAccountLabel: UILabel!
    @IBOutlet weak var userAccountPassword: UILabel!
    @IBOutlet weak var userAccountPermissions: UILabel!

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    let db = Firestore.firestore()
    struct User {
        var UID: String
        var firstName: String
        var lastName: String
    }
    // Create an array of user objects
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        populateUsers {
            self.setAccountButtons()
        }
    }
    
    func populateUsers( completion: @escaping ()-> Void) {
        db.collection("users").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting users: \(err)")
            } else {
                for document in snapshot!.documents {
                    let userFirstName = document.get("firstName") as! String
                    let userLastName = document.get("lastName") as! String
                    self.users.append(User(UID: document.documentID, firstName: userFirstName, lastName: userLastName))
                    
                    print(self.users)
                    
                }
            }
            print(self.users)
            completion()
        }
        
    }
    
    func setAccountButtons() {
        
        for user in users {
            let button = UIButton()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.setTitle(String(describing: user.firstName + user.lastName), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.7607843137, blue: 0.7607843137, alpha: 1), for: .normal)
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        }
    }
  
    @objc func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func onShareBtnTapped(_ sender: Any) {
        
    }

    @IBAction func onBackBtnTapped(_ sender: Any) {
        // Create new view controller obj
        let landingPageViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.landingPageViewControllerID) as! LandingPageViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(landingPageViewController, animated: true)
  
    }
}
