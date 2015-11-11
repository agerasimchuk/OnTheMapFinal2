//
//  convienceModel.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/26/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FBSDKLoginKit
import FBSDKCoreKit

class convienceModel: NSObject{

    //WHAT IS A SINGLETON: https://thatthinginswift.com/singletons/
    var students: [studentsModel] = [studentsModel]()
    

    func getStudentData(completionHandler: (success: Bool, data: NSData?, errorString: String)->Void){

//THIS CAN BE LATER MOVED TO THE MODEL AREA
        print("In Student Locations Convience")
   
        let BASE_URL = "https://api.parse.com/1/classes/StudentLocation"
        let params = ["limit": 100, "order": "-updatedAt"]
        let urlString = BASE_URL + escapedParameters(params)
        let url = NSURL(string: urlString)
        //let request = NSURLRequest(URL: url!)
        let request = NSMutableURLRequest(URL: url!)
        
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            //let myData: NSData? = data
           
            if error != nil { // Handle error...
                print("CANNOT DOWNLOAD DATA")
                print("Error: \(error)")
                //let errorString = error
                completionHandler(success: false, data: nil, errorString: "CONNECTION PROBLEMS")
                
            }else{
                print("SUCCESS")
                completionHandler(success: true, data: data, errorString: "Success")

            }
        }
                task.resume()
    }
    
 
    
     func getStudentLocations(completionHandler: (success: Bool, studentData: [[String: AnyObject]]!, errorString: String?)-> Void){
        
        getStudentData(){(success, data, errorString) in

            if success{
                do{
                    print("THIS IS DATA: \(data!)")
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
                    if let results = parsedData.valueForKey("results") as? [[String: AnyObject]]{
                    print("MY RESULTS ARE: \(results)")
                    completionHandler(success: true, studentData: results, errorString: "Data is good")
                    }else{

                        completionHandler(success: false, studentData: nil, errorString: "Data Problems")
                    }

                }catch
                    //NEED TO SET PARSEDDATE TO NIL, OTHERWISE IT WILL THROW AN ERROR IN THE LET BADCREDENTIALS LINE: https://discussions.udacity.com/t/nil-value-if-entering-wrong-credentials/33053/4
        
                    let parsingDataError as NSError {

                        print("JSON error: \(parsingDataError.localizedDescription)")

                        completionHandler(success: false, studentData: nil, errorString: "Data parsing problems")
                        return
                    }
            
                return
            }
            
            else{
                print("PARSED ERROR")
                completionHandler(success: false, studentData: nil, errorString: "There was a problem downloading student data")
                return
            }

            
        }
        //task.resume()
        return
    }
    
    func logoutAction(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()

    }
    

        
    func getRequestToken(userText: String, passText : String, completionHandler: (success: Bool, errorString: String) -> Void) {
 
print("In Token function")
        //printauthenticating...")
        let mysession : String? = nil
        
        var username :String = userText
        var password : String = passText
        
        print("username: \(username)")
        print("password: \(password)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        print("before task: \(request.HTTPBody!)")
        print("before task: \(request)")
        
           
            
        let task = session.dataTaskWithRequest(request) { data, response, error in

            if error != nil { // Handle error…
                print("in error")
                completionHandler(success: false, errorString: "Error login in. Check your Connections.")
                return
            }
            print("after rror")
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let parsedData: NSDictionary?
            do{
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                print("parsedData is: \(parsedData)")
                //self.presentAlert("parsed Data")
                
                
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
                
                print("Bad Credentials: \(badCredentials)")

                // handle error
                completionHandler(success: false, errorString: "Username or Password is wrong")
                return
            }
            
            if let mysession = parsedData?.valueForKey("session") as? [String: AnyObject]{
                let sessionID = mysession["id"]
                print("Will login now with sessionsID: \(sessionID)")
                completionHandler(success: true, errorString: "No errors found")
                
            }else{
                print("mysession or sessionID is nil")
                completionHandler(success: false, errorString: "Error login in")
                
            }

        }
            task.resume()

    }
     
    func loginWithFacebook(fbToken: String, completionHandler: (success: Bool, errorString: String) -> Void) {
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

            do{
                let parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                print("parsedData is: \(parsedData)")
                
                completionHandler(success: true, errorString: "Login Successful")
                //self.completeLogin()
                
                
            }catch
                let parsingDataError as NSError {
                    print("JSON error: \(parsingDataError.localizedDescription)")
                     completionHandler(success: false, errorString: "Could not get correct information")
            }

        }
        task.resume()
    }
    
    func addLocation(first: String, second: String, url: String, lat: Double, long: Double, completionHandler: (success: Bool, errorString: String) -> Void){
        
    
    
        let first: String? = first
        let second: String? = second
        let lat: Double? = lat
        let long: Double? = long
        
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.HTTPMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        print("First: \(first)")
        print("lastName: \(second!)")
        print("mediaURL: \(url)")
        print("latitude: \(lat)")
        
            request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(first!)\", \"lastName\": \"\(second!)\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat!), \"longitude\": \(long!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        print("THIS IS REQUST BODY: \(request)")
    
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error…
                 
                    print("ERROR ERROR")
            completionHandler(success: false, errorString: "Error posting data. Check your network connections.")
            return
                }else{
                    
                    
                    //PARSE DATA AND CHECK IF POSTING WAS SUCCESSFUL OR HAD FAILED
                    let parsedData: NSDictionary?
                    do{
                    parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print("parsedData is: \(parsedData)")
                    //self.presentAlert("parsed Data")
                    
                    
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
                        
                        print("Bad Credentials: \(badCredentials)")

                        // handle error
                        completionHandler(success: false, errorString: "Unauthorized request")
                        return
                    }

                    completionHandler(success: true, errorString: "Posted new locaiton")
                    print("THIS IS DATA: \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
                }
        }

              task.resume()
        
        return
    }
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        print("URLVARS: \(urlVars)")
            
        for (key, value) in parameters {
            
            print("KEY : \(key)")
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }


    
    class func sharedInstance() -> convienceModel {
        
        struct Singleton {
            static var sharedInstance = convienceModel()
        }
        
        return Singleton.sharedInstance
    }

    
   
}
 