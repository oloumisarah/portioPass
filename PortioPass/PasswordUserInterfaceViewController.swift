//  PasswordUserInterfaceViewController.swift
//  PotrioPass
//
//  Created by sarah oloumi on 2020-10-23.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//

import UIKit

import FirebaseAuth
import Firebase

class PasswordUserInterfaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var accountStackView: UIStackView!
    @IBOutlet weak var userListStackView: UIStackView!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var shareExpDateLabel: UILabel!
    @IBOutlet weak var sharePermLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var permPicker: UIPickerView!
    var permissionsList: [String]!
    
    private var userCollectionRef: CollectionReference!
    private var currentUser : DocumentReference!
    private var firstNameSelectedUser : String?
    private var lastNameSelectedUser : String?
    private var selectedUID: String?
    private var shareDateExp : String?
    private var selectedPerm : String?
    
    private var selectedButton : RecipientButton?
    
    
    
    struct User {
        var UID: String
        var firstName: String
        var lastName: String
    }

    // Create an array of user objects
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (PortioPassVariables.accountCredentials.accountPermissions == "Use+Change+Share") {
            permissionsList = ["Use","Use+Share", "Use+Change+Share"]
            selectedPerm = permissionsList[0]
        }
        else if(PortioPassVariables.accountCredentials.accountPermissions == "Use+Share") {
            permissionsList = ["Use"]
            selectedPerm = permissionsList[0]
        }
        else {
            selectedPerm = ""
            datePicker.isHidden = true
            permPicker.isHidden = true
            shareExpDateLabel.text = "Share Exp. Date : N\\A"
            sharePermLabel.text = "Share Permissions: N\\A"
        }
        
        // Need to pass data from our own view to the picker view
        self.permPicker.delegate = self
        self.permPicker.dataSource = self
        
        // set a default date to one month in advance for sharing.
        let dateFormatter = DateFormatter()
        datePicker.minimumDate = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let calendar = Calendar.init(identifier: .gregorian)
        var dateComponent = DateComponents()
        dateComponent.month = +1
        datePicker.date = calendar.date(byAdding: dateComponent, to: Date())!
        let date = dateFormatter.string(from: datePicker.date)
        shareDateExp = date

        
        navBar.topItem?.title = PortioPassVariables.accountCredentials.accountName!
        
        userCollectionRef = Firestore.firestore().collection("users")
        currentUser = userCollectionRef.document(Auth.auth().currentUser!.uid)
        
        if(PortioPassVariables.accountCredentials.accountPermissions != "Use") {
            populateUsers {
                self.setUserAccountButtons()
            }
        }
        
        populatePassword()
        shareBtn.isEnabled = false
      
    }
    
    func populatePassword(){
        let accountUsername = UILabel()
        let accountPassword = UILabel()
        let accountDate = UILabel()
        
        accountUsername.text = "User Name: " + PortioPassVariables.accountCredentials.accountUsername!
        accountPassword.text = "Password: " + PortioPassVariables.accountCredentials.accountPassword!
        accountDate.text = "Creation Date: " + PortioPassVariables.accountCredentials.accountCreationDate!
  
        accountUsername.translatesAutoresizingMaskIntoConstraints = false
        accountPassword.translatesAutoresizingMaskIntoConstraints = false
        accountDate.translatesAutoresizingMaskIntoConstraints = false
        
        accountStackView.insertArrangedSubview(accountUsername, at: 0)
        accountStackView.insertArrangedSubview(accountPassword, at: 1)
        accountStackView.insertArrangedSubview(accountDate, at: 2)
    }
    
    @IBAction func datePicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.string(from: datePicker.date)
        
        shareDateExp = date
    }
    
    // Sets the num of columns of data for permission picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Sets the rows of data for permission picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (permissionsList == nil) {
            return 0;
        }
        return permissionsList.count
    }
    // Fill up the rows with data (this gets called for each row 1 by 1)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return permissionsList[row]
    }
    // This gets called when a user picks a permission
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPerm = permissionsList[row]
    }
    
    func populateUsers( completion: @escaping ()-> Void) {
        userCollectionRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting users: \(err)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                for document in snap.documents {
                    // need to remove current user from the list
                    if (self.currentUser?.documentID != document.documentID) {
                        let data = document.data()
                        let userFirstName = data["firstName"] as? String ?? ""
                        let userLastName = data["lastName"] as? String ?? ""
                        self.users.append(User(UID: document.documentID, firstName: userFirstName, lastName: userLastName))
                    }
                }
            }
            completion()
        }
    }
    
    func setUserAccountButtons() {
        for user in users {
            let button = RecipientButton()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.setTitle(String(describing:user.firstName + " " + user.lastName), for: .normal)
            button.recipientUID = user.UID
            button.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.7607843137, blue: 0.7607843137, alpha: 1), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .selected)
            userListStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ sender: RecipientButton) {
        if (selectedButton != nil) {
            selectedButton?.isSelected = false
        }
        sender.isSelected = true
        if (sender.isSelected) {
            let username = sender.currentTitle
            if let first = username!.components(separatedBy: " ").first {
                firstNameSelectedUser = first
            }
            if let last = username!.components(separatedBy: " ").last {
                lastNameSelectedUser = last
            }
            selectedUID = sender.recipientUID
            selectedButton = sender
            shareBtn.isEnabled = true
        }
    }
    
    @IBAction func onShareBtnTapped(_ sender: Any) {
        let permission = selectedPerm?.trimmingCharacters(in: .whitespacesAndNewlines)
        let accountUID = PortioPassVariables.accountCredentials.accountUID!
        let accountData: [String: Any] = [
            accountUID: [
                "accountName":  PortioPassVariables.accountCredentials.accountName!,
                "accountUsername":  PortioPassVariables.accountCredentials.accountUsername!,
                "accountPassword":  PortioPassVariables.accountCredentials.accountPassword!,
                "accountCreationDate": PortioPassVariables.accountCredentials.accountCreationDate!,
                "accountPermissions": permission,
                "accountShareExpDate": self.shareDateExp
            ]
        ]
        
        let docRef = userCollectionRef.document(selectedUID!)
        let accountToShare = "Accounts."+accountUID
       // Share Password with the user
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                // If "Accounts" is not empty update it.
                if ((dataDescription?["Accounts"]) != nil) {
                    // Check if the user already has an account with those credentials.. if they do, user can't reshare to prevent malicious intent.
                    if (dataDescription?[accountToShare] != nil) {
                        return
                    }
                    docRef.setData(["Accounts" : accountData], merge: true){ err in
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
                    docRef.setData(["Accounts" : accountData]) { err in
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
        }
    }

    @IBAction func onBackBtnTapped(_ sender: Any) {
        backToLandingPage()
    }
    
    
    @IBAction func onDeleteBtnTapped(_ sender: Any) {
        let currentAccount = "Accounts." + PortioPassVariables.accountCredentials.accountUID!
        self.currentUser.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                // If accounts is not empty
                if ((dataDescription?["Accounts"]) != nil) {
                    // Find the current account and delete
                    self.currentUser.updateData([currentAccount: FieldValue.delete()]){ err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Account successfully deleted!")
                            self.backToLandingPage()
                        }
                    }
                }
                
            } else {
                print("Error. User data not found.")
            }
        }
    }
    
    func backToLandingPage(){
        // Create new view controller obj
        let landingPageViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.landingPageViewControllerID) as! LandingPageViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(landingPageViewController, animated: true)
    }
    
}
