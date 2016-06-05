//
//  RestaurantsListTableViewController.swift
//  RestaurantsApp
//
//  Created by Andrea Borghi on 11/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class RestaurantsListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let reuseIdentifier = "RestaurantCell"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName:"RestaurantsListTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        formatter.numberStyle = .DecimalStyle
        formatter.maximumSignificantDigits = 2
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showOnMap" {
            let destination = segue.destinationViewController as MapViewController
            var annotationsArray = [AnyObject]()
            
            let restaurant = fetchedResultController.objectAtIndexPath(tableView.indexPathForSelectedRow()!) as Restaurant
            var annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.subtitle = String(formatter.stringFromNumber(restaurant.distance)! + " km")
            annotation.coordinate = restaurant.location.coordinate
            annotationsArray.append(annotation)
            
            destination.annotations = annotationsArray
            destination.title = restaurant.name
        } else if segue.identifier == "showAll" {
            let destination = segue.destinationViewController as MapViewController
            var annotationsArray = [AnyObject]()
            
            for place in fetchedResultController.fetchedObjects! {
                let restaurant = place as Restaurant
                var annotation = MKPointAnnotation()
                annotation.title = restaurant.name
                annotation.subtitle = String(formatter.stringFromNumber(restaurant.distance)! + " km")
                annotation.coordinate = restaurant.location.coordinate
                
                annotationsArray.append(annotation)
            }
            
            destination.annotations = annotationsArray
            destination.title = annotationsArray[0].title
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showOnMap", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    // Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RestaurantsListTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? RestaurantsListTableViewCell
        
        if cell == nil {
            cell = RestaurantsListTableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        
        let restaurant = fetchedResultController.objectAtIndexPath(indexPath) as Restaurant
        cell!.nameLabel.text = restaurant.name
        cell!.addressLabel.text = restaurant.address
        cell!.distanceLabel.text = String(formatter.stringFromNumber(restaurant.distance)! + " km")
        return cell!
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
}