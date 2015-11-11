//
//  ViewController.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 9/21/15.
//  Copyright (c) 2015 Anya Gerasimchuk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import QuartzCore




class loginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //CHECK IF FB TOKEN EXISTS
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            completeLogin()
        }
        else
        {
        
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
         
            FBSDKAccessToken.currentAccessToken()?.tokenString!
            print(FBSDKAccessToken.currentAccessToken()?.tokenString!)
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
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
                fbToken = FBSDKAccessToken .currentAccessToken().tokenString
                print("The token is:\(fbToken)")
                convienceModel.sharedInstance().loginWithFacebook(fbToken!){success, errorString in
                    if success {
                        self.completeLogin()
                    }else{
                        print("ugly butt")
                    }

                }
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    func presentAlert(messageString: String){
        dispatch_async(dispatch_get_main_queue(), {
        
            
            //SHAKE ALERT
            let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
            shake.duration = 0.1
            shake.repeatCount = 2
            shake.autoreverses = true
            
            
            let from_point:CGPoint = CGPointMake(self.loginButton.center.x - 5, self.loginButton.center.y)
            let from_value:NSValue = NSValue(CGPoint: from_point)
            
            let to_point:CGPoint = CGPointMake(self.loginButton.center.x + 5, self.loginButton.center.y)
            let to_value:NSValue = NSValue(CGPoint: to_point)
            
            shake.fromValue = from_value
            shake.toValue = to_value
            
            self.loginButton.layer.addAnimation(shake, forKey: "position")

        //FORM AN ALERT
        let message = messageString
        
        
        let alertController = UIAlertController(title: "NEED INFORMATION!", message: message, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction (title: "ok", style: UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
    })
        
    }

    
    //LOGIN VIE UDACITY
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if userText.text!.isEmpty {
            presentAlert("Username Empty.")
        } else if passText.text!.isEmpty {
            debugLabel.hidden = false
            
        } else {
            
            convienceModel.sharedInstance().getRequestToken(userText.text!, passText: passText.text!){ success, errorString in
                
                print("LOGING SUCCESS OR NOT: \(success)")
                               if success{
                    self.completeLogin()
                }else{
                    self.presentAlert(errorString)

                
                }
            }

    }
}

    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            print("In completeLogin")
                      let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapView")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

}


