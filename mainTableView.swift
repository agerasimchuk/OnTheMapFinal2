//
//  mainTableView.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/13/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit


class mainTableView: UIViewController, UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource{
    
    
    var students: [studentsModel] = [studentsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //EXPLANATION ON WHY WE NEED DATASOURCE AND DELEGATE FOR A VIEW TO DISPLAY INFORMATION IN A TABLE: http://stackoverflow.com/questions/11465579/how-to-set-up-uitableview-within-a-uiviewcontroller-created-on-a-xib-file
        
          self.tableView.delegate = self
        self.tableView.dataSource = self
        
        convienceModel.sharedInstance().getStudentLocations { (success, studentData, errorString) in
            if success{
                self.displayStudents(studentData)
            }else{
                
            }
        }
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    func displayStudents(studentData: [[String: AnyObject]]){
        
        let results = studentData
        
        self.students = studentsModel.studentsFromResults(results)
        //print("THIS IS STUDENS: \(self.students)")
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            
            
        }

    }

    //FORMATTING FOR THE TABLE http://www.raywenderlich.com/87975/dynamic-table-view-cell-height-ios-8-swift
    
    @IBOutlet var tableView: UITableView!

    

   

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(2)
          
            
        print("THIS IS MY TABLE")
        print(students)
            
        /* Get cell type */
        let cellReuseIdentifier = "mainTableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!


        
        
        /* Set cell defaults */
        //cell.textLabel!.text = student.first + student.last
            cell.textLabel!.text = "\(student.first),  \(student.last)"

            //cellSub.text = student.subtitle
            cell.detailTextLabel?.text = student.subtitle
            
        
        
        // TODO: Get the poster image, then populate the cell's image view
        
        return cell
    }
    
        var url:String = ""
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {

        
        url = students[indexPath.row].subtitle
        
        let app = UIApplication.sharedApplication()
        
        //MAKE SURE THE URL IS VALID AND DOES NOT RETURN NIL
        if let myUrl : NSURL = NSURL(string: url){
            print("THIS IS URL: \(myUrl)")
            app.openURL(myUrl)
            
        }else{
            print("NO VALID URL")
        }
        
        

        /*
        if control == annotationView.rightCalloutAccessoryView {
        
        }
*/
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
    
    @IBAction func logoutButton(sender: AnyObject) {
        func completeLogout() {
            
            convienceModel.sharedInstance().logoutAction()
            
            
            
            dispatch_async(dispatch_get_main_queue(), {
                print("In completeLogout")
                
                
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController")
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
        

    }
}
