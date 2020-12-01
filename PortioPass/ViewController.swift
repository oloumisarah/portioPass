//
//  ViewController.swift
//  PotrioPass
//
//  Created by sarah oloumi on 2020-10-22.
//  Copyright © 2020 sarah oloumi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

  
    
    @IBOutlet weak var PortioPassLabel: UILabel!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyle()
 
    }
    
    /*
     Sets up the style of page
     */
    func setUpStyle() {
        
        let purpleOne = #colorLiteral(red: 0.2862745098, green: 0.2901960784, blue: 0.2901960784, alpha: 1); let purpleTwo = #colorLiteral(red: 0.2862745098, green: 0.3529411765, blue: 0.3529411765, alpha: 1); let blueOne = #colorLiteral(red: 0.2705882353, green: 0.431372549, blue: 0.431372549, alpha: 1); let blueTwo = #colorLiteral(red: 0.2705882353, green: 0.5333333333, blue: 0.5333333333, alpha: 1); let blueThree = #colorLiteral(red: 0.2901960784, green: 0.6980392157, blue: 0.6980392157, alpha: 1); let blueFour = #colorLiteral(red: 0.3215686275, green: 0.7450980392, blue: 0.7490196078, alpha: 1); let blueFive = #colorLiteral(red: 0.5294117647, green: 0.8235294118, blue: 0.8235294118, alpha: 1); let blueSix = #colorLiteral(red: 0.6862745098, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        
        // Do any additional setup after loading the view.
        PortioPassLabel.portioGradientColor(gradientColors: [blueSix, blueFive, blueFour, blueThree, blueTwo, blueOne,purpleTwo, purpleOne])
        SignUpButton.layer.cornerRadius = 15
        LoginButton.layer.cornerRadius = 15
        LoginButton.layer.borderColor = #colorLiteral(red: 0.2903735017, green: 0.7607288099, blue: 0.6868186358, alpha: 1)
        LoginButton.layer.borderWidth = 1
    }


    @IBAction func onSignUpButtonTapped(_ sender: Any) {
        // Create new view controller obj
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.signupPageViewControllerID) as! SignUpViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        
        // Create new view controller obj
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: PortioPassVariables.StoryboardConstants.loginPageViewControllerID) as! LoginViewController
        // Go to the other view controller
        self.navigationController?.pushViewController(loginViewController, animated: true)
        
    }
}

