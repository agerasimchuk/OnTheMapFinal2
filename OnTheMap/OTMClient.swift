//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 9/24/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class OTMCClient:  NSObject, FBSDKLoginButtonDelegate {
    var fbToken : String? = nil
    
    
    
    
    //METHODS FOR FACEBOOK LOGIN BUTTON
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                print("toke here")
                print(FBSDKAccessToken .currentAccessToken().tokenString)
                fbToken = FBSDKAccessToken .currentAccessToken().tokenString
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    
    // END METHODS FOR BACEBOOK LOGIN BUTTON
    
    

    
}