//
//  studentLocationsModel.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/2/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class studentLocationsModel: UIViewController{
    
    func getStudentLocations(){
        
        print("In Student Locations Model")
        
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
                
                
                //BUILD THE ARRAY
                let results = parsedData.valueForKey("results") as! [[String: AnyObject]]
            
                
                print("reuslt are here: \(results)")

                //GET ANNOTATIONS ARRAY, CONVERT TO MKPOINTANNOTATIONS AND ADD TO MAP
               /*
                var annotations = [MKPointAnnotation]()
                
                for Dictionary in results{
                    let lat = CLLocationDegrees(Dictionary["latitude"] as! Double)
                    let long = CLLocationDegrees(Dictionary["longitude"] as! Double)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = Dictionary["firstName"] as! String
                    let last = Dictionary["lastName"] as! String
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotations.append(annotation)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.myMap.addAnnotation(annotation)
                    })
                
                }
                */
                
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
     
        
        
        
}
   
    
}
