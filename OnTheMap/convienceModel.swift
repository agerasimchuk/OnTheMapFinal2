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

class convienceModel: NSObject{

    //WHAT IS A SINGLETON: https://thatthinginswift.com/singletons/
    
    
    func getStudentLocations(completionHandler: (success: Bool, studentData: [[String: AnyObject]], errorString: String?)-> Void){
//THIS CAN BE LATER MOVED TO THE MODEL AREA
print("In Student Locations Convience")

let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")


let session = NSURLSession.sharedSession()




let task = session.dataTaskWithRequest(request) { data, response, error in
    if error != nil { // Handle error...
        return
    }
    
    do{
        let parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
            if let results = parsedData.valueForKey("results") as? [[String: AnyObject]]{
                    completionHandler(success: true, studentData: results, errorString: "All is good")
            }
        //print("reuslt are here: \(results)")
        }catch
        //NEED TO SET PARSEDDATE TO NIL, OTHERWISE IT WILL THROW AN ERROR IN THE LET BADCREDENTIALS LINE: https://discussions.udacity.com/t/nil-value-if-entering-wrong-credentials/33053/4
        
        let parsingDataError as NSError {
            //let parsedData = nil
            print("JSON error: \(parsingDataError.localizedDescription)")
            // report error…
            return
            
            }

        }
        task.resume()

      return
       
    }
    
    /*
    func getAnnotations(){
        //GET ANNOTATIONS ARRAY, CONVERT TO MKPOINTANNOTATIONS AND ADD TO MAP
        
        var annotations = [MKPointAnnotation]()
        
        for Dictionary in results{
            let lat = CLLocationDegrees(Dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(Dictionary["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = Dictionary["firstName"] as! String
            let last = Dictionary["lastName"] as! String
            let mediaURL = Dictionary["mediaURL"] as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.myMap.addAnnotation(annotation)
            })
            
        }
        
    }
*/
    
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
    
    class func sharedInstance() -> convienceModel {
        
        struct Singleton {
            static var sharedInstance = convienceModel()
        }
        
        return Singleton.sharedInstance
    }

    
   
}
 