//
//  mainMapView.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 9/29/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class mainMapView: UIViewController, MKMapViewDelegate{
    

    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var addNewLocation: UIBarButtonItem!

    //var annotation: [locationModel] = [locationModel]()

   
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ASK FOR AUTHORISATION FROM USER
        self.locationManager.requestAlwaysAuthorization()
        
        //for useq in foreground
            self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        self.myMap.delegate = self
        
        
        //THIS CAN BE LATER MOVED TO THE MODEL AREA
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
        
        
        

        
        
        
        
        
        
        
        /*
        @IBAction func loginButtonTouch(sender: AnyObject) {
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
        if success {
        self.completeLogin()
        } else {
        self.displayError(errorString)
        }
        }
        }

        studentLocationsModel.getStudentLocations(){ (results, error) in
            if results{
                print("SUCCESS")
            }else{
                print("FAILURE")
            }
            
        }
  */
      
        //print("me is: \(me)")
        
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is mainMapView {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Green
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
                    return pinAnnotationView
        }
        
        return nil
    }
    /*
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let locati
    }
*/
    
}
/*
    func createAnnotations(results:String){
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
}
*/

    /*
    @IBAction func addPinAction(sender: AnyObject) {
        print("ADD PIN?")
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }

*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
