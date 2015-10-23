//
//  addLocationView.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/17/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//
//http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
//
import Foundation
import UIKit
import CoreLocation
import MapKit


class addLocationView: UIViewController, UISearchBarDelegate{
    
    let locationManager = CLLocationManager()
  
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var lat: Double = 0.0
    var long: Double = 0.0
    var mytitle: String = ""
    
    
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        /*
//1: Once you click the keyboard search button, the app will dismiss the presented search controller you were presenting over the navigation bar. Then, the map view will look for any previously drawn annotation on the map and remove it since it will no longer be needed.
*/
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        /*
//2: the search process will be initiated asynchronously by transforming the search bar text into a natural language query, the ‘naturalLanguageQuery’ is very important in order to look up for -even an incomplete- addresses and POI (point of interests) like restaurants, Coffeehouse, etc.
*/
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    @IBAction func addPinAction(sender: AnyObject) {
        print("ADD PIN?")
        

        lat = self.pointAnnotation.coordinate.latitude
        long = self.pointAnnotation.coordinate.longitude
        mytitle = self.pointAnnotation.title!
        
        
        //print("TITLE IS: \(mytite)")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"A\", \"lastName\": \"B\",\"mapString\": \(self.pointAnnotation.title), \"mediaURL\": \"https://udacity.com\",\"latitude\": \(self.pointAnnotation.coordinate.latitude), \"longitude\": \(self.pointAnnotation.coordinate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \(title), \"mediaURL\": \"https://udacity.com\",\"latitude\": \(lat), \"longitude\": \(long)}".dataUsingEncoding(NSUTF8StringEncoding)
        //print("THIS IS MY JSON: \(request.HTTPBody)")
        
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Anya\", \"lastName\": \"G\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": \(lat), \"longitude\": \(long)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("HERE")
                return
            }
            print("THERE")
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            //let parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            //print(parsedData)

        }
        task.resume()
        
    }

    
    }

