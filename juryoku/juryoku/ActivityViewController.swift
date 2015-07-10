//
//  ViewController.swift
//  juryoku
//
//  Created by Joshua Book on 7/9/15.
//  Copyright (c) 2015 Boovius Projects. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController, UITableViewDataSource {
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    @IBOutlet weak var doButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var activities = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "lift the weight"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: (&error)) as? [NSManagedObject]
        
        if let results = fetchedResults {
            activities = results
        } else {
            println("Could not fetch results from core data \(error), \(error!.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityCell
        
        let activity = activities[indexPath.row] as! Activity
        
        cell.activityTitle.text = activity.activity.uppercaseString
        cell.doneLastAt.text = doneLastAt(activity)
        cell.count.tag = indexPath.row
        cell.count.setTitle("\(activity.weekly())", forState: UIControlState.Normal)
        cell.count.addTarget(self, action: "doActivity:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func doneLastAt(activity: Activity) -> String {
        if let daysAgo = DateProcessor.daysBetween(activity.doneLastAt, incomingSecond: NSDate()) {
            var expression: String
            switch daysAgo {
            case 0:
                expression = "today!"
            case 1:
                expression = "1 day ago"
            case daysAgo where daysAgo > 1:
                expression = "\(daysAgo) days ago"
            default:
                expression = "not yet done"
            }
            return expression
        } else {
            return "not yet done"
        }
        
    }
    
    @IBAction func doActivity(sender: UIButton) {
        let activity = activities[sender.tag] as! Activity
        
        let entity = NSEntityDescription.entityForName("Doing", inManagedObjectContext: managedContext)
        
        let doing = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Doing
        doing.activity = activity
        doing.createdAt = NSDate()
        activity.doneLastAt = doing.createdAt
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        } else {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addName(sender: AnyObject) {
        var alert = UIAlertController(
            title: "New activity",
            message: "Add a new activity",
            preferredStyle: .Alert
        )
        
        let saveAction = UIAlertAction(
            title: "Save",
            style: UIAlertActionStyle.Default,
            handler: {(action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as! UITextField
                self.saveActivity(textField.text)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveActivity(name: NSString) {
        let entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedContext)
        
        let activity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        activity.setValue(name, forKey: "activity")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        activities.append(activity)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let activity = activities[indexPath.row] as! Activity
        
        managedContext.deleteObject(activity)
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not delete \(activity), \(error), \(error?.userInfo)")
        } else {
            activities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            self.tableView.reloadData()
        }
    }
}

