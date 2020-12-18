//
//  AddPasswordViewController.swift
//  PortioPass
//
//  Created by sarah oloumi on 2020-11-02.
//

import Foundation
import UIKit

import FirebaseAuth
import Firebase

class AddPasswordViewController: UIViewController {
    

    let db = Firestore.firestore()
    
    
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var accountUsername: UITextField!
    @IBOutlet weak var accountPassword: UITextField!
    @IBOutlet weak var dateUpdated: UILabel!
    @IBOutlet weak var passwordPermission: UILabel!

    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpStyle()
        setTimeAdded()
        addPriv()
        
        websiteTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        accountUsername.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        accountPassword.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)

        addBtn.isEnabled = false
    }
    
    func setUpStyle() {
        websiteTextField.useUnderline()
        accountUsername.useUnderline()
        accountPassword.useUnderline()
    }
    
    func setTimeAdded() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        dateUpdated.text = "\(formattedDate)"
    }
    
    func addPriv() {
        // By default the password is set to Use - Change - Share , specifying that the owner has the highest level of priviledge.
        passwordPermission.text = "Use+Change+Share"
    }
    @objc func editingChanged(_ textField: UITextField) {
        
        if textField.text?.count == 1 {
            if textField.text == " " {
                textField.text = ""
                return
            }
        }
        guard
            let website = websiteTextField.text, !website.isEmpty,
            let username = accountUsername.text, !username.isEmpty,
            let password = accountPassword.text, !password.isEmpty
        else {
            addBtn.isEnabled = false
            return
        }
        addBtn.isEnabled = true
    }

    @IBAction func onCancelBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddBtnTapped(_ sender: Any) {
        let trimmedURL = websiteTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Maybe get firestore to do this later... that way you know for sure they are never colliding.
        let uuid = UUID().uuidString
        // Create user account object for new account being added
        let accountData: [String: Any] = [
            uuid: [
                "accountName": trimmedURL,
                "accountUsername": accountUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                "accountPassword": accountPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                "accountCreationDate": dateUpdated.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                "accountPermissions": passwordPermission.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            ]
        ]
        // Get the user who is adding a new account
        let userData = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        
        // Get data
        userData.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                // If "Accounts" is not empty update it.
                if ((dataDescription?["Accounts"]) != nil) {
                    userData.setData(["Accounts" : accountData], merge: true){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                        }
                    }
                }
                // if "Accounts" is empty
                else {
                    // set the user Data if there is nothing in accounts.
                    userData.setData(["Accounts" : accountData]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
                
            } else {
                print("Error. User data not found.")
            }
            ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
