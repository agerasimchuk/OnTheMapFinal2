//
//  annotationsModel.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 9/29/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import MapKit

class annotationsModel: NSObject, MKAnnotation {
    var mytitle: String = ""
    var mysubtitle: String = ""
    
    private var coord:  CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D{
        get {
            return coord
        }
    }
    
    func setCoordinate (newCoordinate: CLLocationCoordinate2D){
        self.coord = newCoordinate
    }
    
    //let locationName: String
    //let discipline: String
    //let coordinate: CLLocationCoordinate2D
    
    /*
    init(locationName: String, discipline: String, coordinate: CLLocationCoordinate2D){
        //self.title = title
        self.locationName = locationName
        self.discipline = discipline
        //self.coordinate = coordinate
        
        super.init()
    }
*/
    
    }
