//
//  studentsModel.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/16/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit

//private let sharedInstance = studentsModel(dictionary: [String : AnyObject])


private var students: [studentsModel] = [studentsModel]()

class studentsModel {
    
    var first = ""
    var last = ""
    var subtitle = ""

    
    private init(dictionary: [String : AnyObject]) {
      
        
        first = dictionary["firstName"] as! String
        last = dictionary["lastName"] as! String
        subtitle = dictionary["mediaURL"] as! String
    }
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [studentsModel] {
        
        var location = [studentsModel]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for result in results {
            location.append(studentsModel(dictionary: result))

        }
        
        return location
    }
    
    class var sharedInstance: studentsModel {
        return self.sharedInstance
    }
    
}

/*
for Dictionary in results{
let lat = CLLocationDegrees(Dictionary["latitude"] as! Double)
let long = CLLocationDegrees(Dictionary["longitude"] as! Double)
let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

let first = Dictionary["firstName"] as! String
let last = Dictionary["lastName"] as! String
*/