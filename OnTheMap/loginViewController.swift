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


class loginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    var fbToken : String? = nil
    
    
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
            


        
        
        
            print("ha")
            print(FBSDKAccessToken.currentAccessToken()?.tokenString!)
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
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
                //print(FBSDKAccessToken .currentAccessToken().tokenString)
                fbToken = FBSDKAccessToken .currentAccessToken().tokenString
                print("The token is:\(fbToken)")
                loginWithFacebook()
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    
    // END METHODS FOR BACEBOOK LOGIN BUTTON

    
    //LOGIN VIE UDACITY
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if userText.text!.isEmpty {
            debugLabel.hidden = false
            debugLabel.text = "Username Empty."
        } else if passText.text!.isEmpty {
            debugLabel.hidden = false
            debugLabel.text = "Password Empty."
        } else {
            
                 self.getRequestToken()
        }

    }

    
    func getRequestToken(){
        //printauthenticating...")
        let mysession : String? = nil
        
        var username :String = ""
        var password : String = ""
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userText!.text!)\", \"password\": \"\(passText!.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let parsedData: NSDictionary?
            do{
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                print("parsedData is: \(parsedData)")
                
                
            } catch
                //NEED TO SET PARSEDDATE TO NIL, OTHERWISE IT WILL THROW AN ERROR IN THE LET BADCREDENTIALS LINE: https://discussions.udacity.com/t/nil-value-if-entering-wrong-credentials/33053/4
                
                let parsingDataError as NSError {
                    parsedData = nil
                    print("JSON error: \(parsingDataError.localizedDescription)")
                    // report error…
                    return
            }
            
            
            let badCredentials: String? = parsedData?.valueForKey("error") as? String
            if badCredentials != nil {

                    print(badCredentials)
                    self.debugLabel.text = badCredentials
                    
                    // handle error
                    return
            }
           
            if let mysession = parsedData?.valueForKey("session") as? [String: AnyObject]{
                let sessionID = mysession["id"]
                print("Will login now with sessionsID: \(sessionID)")
            }else{
                print("mysession or sessionID is nil")
            }
           self.completeLogin()
            
            
            
            
            /*}else{
                    dispatch_async(dispatch_get_main_queue()){
                            debugLabel.text = "Could not find credentials"
                    }
                }
*/
            
            //let mysession = parsedResponse["session"]
            //let sessionID = mysession
            //print("and sessionID is : \(sessionID)")
             //           print("and sessionID is : \(sessionID)")
    
            }
      //self.completeLogin()
        

      
         task.resume()
        

        
        //self.completeLogin()

    }
    /*--CORRECT FORMATING FOR LATER
    request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.username.text)\", \"password\": \"\(self.password.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
    
    */
    
    func loginWithFacebook(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(fbToken)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil {
    // Handle error...
        return
        }
            //print("Data is: \(data)")
            
        let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print("newData is: \(newData)")
            
            
            /*
let parsedData = try? NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
*/

            do{
                let parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print("parsedData is: \(parsedData)")
                    self.completeLogin()
                
                
            }catch
                let parsingDataError as NSError {
                print("JSON error: \(parsingDataError.localizedDescription)")
            }

         
        //print(NSString(data: parsedData, encoding: NSUTF8StringEncoding))
            
        }
    task.resume()
    }
    
/*
    @IBAction func loginWithFacebook(sender: AnyObject) {
        authenticateWithViewController(self){(success, errorString) in
            if success {
                self.completeLogin()
            }else{
                print("ugly butt")
            }
        }
    }
  */  
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* Chain completion handlers for each request so that they run one after the other */
        /*
        self.getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                
                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                    
                    if success {
                        print("You did it! We have finished authenticating through the website!")
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
*/
    }

    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            print("In completeLogin")
            //self.debugLabel.text = ""
            //let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! UITabBarController
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapView")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }


}

