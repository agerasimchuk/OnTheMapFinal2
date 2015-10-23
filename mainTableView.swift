//
//  mainTableView.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/13/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit


class mainTableView: UIViewController, UITableViewDelegate{
    
    
    var students: [studentsModel] = [studentsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
    
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
                //BUILD THE ARRAY
                
                self.students = studentsModel.studentsFromResults(results)
                print("THIS IS STUDENS: \(self.students)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    print("HAAHAHAHAHA")

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

    }

    
    @IBOutlet var tableView: UITableView!

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("THIS IS MY TABLE")
        print(students)
        /* Get cell type */
        let cellReuseIdentifier = "mainTableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = student.first
        
        
        // TODO: Get the poster image, then populate the cell's image view
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
