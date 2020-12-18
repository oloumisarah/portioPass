//
//  Variables.swift
//  PortioPass
//
//  Created by sarah oloumi on 2020-11-02.
//

import Foundation

struct PortioPassVariables {
    
    struct StoryboardConstants {
        static let landingPageViewControllerID = "landingpage_viewcontroller"
        static let signupPageViewControllerID = "signup_viewcontroller"
        static let loginPageViewControllerID = "login_viewcontroller"
        static let initPageViewControllerID = "init_viewcontroller"
        static let addPasswordViewControllerID = "addpassword_viewcontroller"
        static let passwordUIViewControllerID = "passwordUserInterface_viewcontroller"
    }
    
    struct accountCredentials {
        static var accountUID : String?
        static var accountCreationDate : String?
        static var accountName : String?
        static var accountUsername : String?
        static var accountPassword : String?
        static var accountPermissions : String?
    }
}


