//
//  locationModel.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/8/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct locationModel {
    
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var mytitle: String = "a"
    var mysubtitle: String = "b"
    
    mutating func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }

    static func locationsFromResults(results: [[String : AnyObject]]) -> [locationModel] {
        
        let location = [locationModel]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
       
        
        return location
    }
    
}

/*
class annotationModel : NSObject, MKAnnotation {
private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

var coordinate: CLLocationCoordinate2D {
get {
return coord
}
}

var mytitle: String = ""
var mysubtitle: String = ""

func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
self.coord = newCoordinate
}
}
*/