//
//  ParseAPI.swift
//  Dine
//
//  Created by YiHuang on 3/15/16.
//  Copyright © 2016 YYZ. All rights reserved.
//

import UIKit
import Parse

class ParseAPI {
    static var sharedInstance = ParseAPI()
    
    class func signUp(username: String, password: String, firstName: String, lastName: String, successCallback: ()->(), failureCallback: (NSError?)->()) {
        let user = PFUser()
        user.username = username
        user.password = password
        user["firstName"] = firstName
        user["lastName"] = lastName
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                successCallback()
            } else {
                failureCallback(error)
            }
            
        }
    
    }
    
    class func signIn(username: String, password: String, successCallback: ()->(), failureCallback: (NSError?)->()) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                successCallback()
                
            } else {
                failureCallback(error)
            }
        }
    
    }
    
    



}
