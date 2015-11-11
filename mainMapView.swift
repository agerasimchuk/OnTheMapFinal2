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
import FBSDKLoginKit
import FBSDKCoreKit


class mainMapView: UIViewController, MKMapViewDelegate{
    

    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var addNewLocation: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!

    
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
        
        convienceModel.sharedInstance().getStudentLocations { (success, studentData, errorString) in
            if success{
                self.makeAnnotations(studentData)
            }else{
                self.presentAlert("Cannot download data")
            }
        }
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        convienceModel.sharedInstance().getStudentLocations { (success, studentData, errorString) in
            if success{
                self.makeAnnotations(studentData)
            }else{
                self.presentAlert("Cannot download data")
            }
        }
    }

    @IBOutlet var errorView: UIVisualEffectView!
    
    func presentAlert(messageString: String){
        

        //FORM AN ALERT
        let message = messageString

        
        let alertController = UIAlertController(title: "NEED INFORMATION!", message: message, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction (title: "ok", style: UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        

        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
       
    }

    
    //ADD ANNOTATIONS TO THE MAPVIEW
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    //MAKE THE SUBTITLE CLICKABLE TO OPEN THE URL
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
     
            if let myUrl : NSURL = NSURL(string: annotationView.annotation!.subtitle!!)!{
                
                 app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
                
            }else{
                print("NO VALID URL")
            }

           
        }
    }

    func makeAnnotations(studentData: [[String: AnyObject]]){
        
        //GET ANNOTATIONS ARRAY, CONVERT TO MKPOINTANNOTATIONS AND ADD TO MAP
        let results = studentData
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
    

    

   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutButton(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        completeLogout()
        
        
    }
    
    func completeLogout() {
        
        convienceModel.sharedInstance().logoutAction()
        
               
        
        dispatch_async(dispatch_get_main_queue(), {
            print("In completeLogout")
            
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    

        
}
