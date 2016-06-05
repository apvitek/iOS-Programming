//
//  Restaurant Extension.swift
//  RestaurantsApp
//
//  Created by Andrea Borghi on 11/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import AddressBookUI

extension Restaurant {
    class func populateDatabaseWithRestaurants(userLocation: CLLocation, context: NSManagedObjectContext) {
        //println("Populate database called")
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurant"
        let span = MKCoordinateSpanMake(0.1, 0.1)
        request.region = MKCoordinateRegionMake(userLocation.coordinate, span)
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            if (error == nil) {
                let locationsArray = response.mapItems as [MKMapItem]
                
                for location in locationsArray {
                    let name = location.name
                    let request = NSFetchRequest(entityName: "Restaurant")
                    request.predicate = NSPredicate(format: "name = %@", name)
                    var error = NSErrorPointer()
                    let matches = context.executeFetchRequest(request, error: error)
                    
                    if (matches == nil) { // Check for errors?
                        //println("No matches")
                    } else if (matches?.count > 1) {
                    } else if (matches?.count == 1){
                        //println("\"\(name)\" already in database")
                    } else {
                        let restaurant = (NSEntityDescription .insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: context)) as Restaurant
                        restaurant.name = name
                        let restaurantPlacemark = location.placemark
                        restaurant.latitude = restaurantPlacemark.location.coordinate.latitude
                        restaurant.longitude = restaurantPlacemark.location.coordinate.longitude
                        let addressDictionary = restaurantPlacemark.addressDictionary
                        restaurant.address = ABCreateStringWithAddressDictionary(addressDictionary, false)
                        restaurant.distance = Restaurant.distanceBetweenUserAndLocation(restaurant.location) as NSNumber
                        
                        //println("New restaurant: \"\(name)\"")
                    }
                }
            }
        }
    }
    
    class func distanceBetweenUserAndLocation(location: CLLocation) -> CLLocationDistance {
        var userLocation = (UIApplication.sharedApplication().delegate as AppDelegate).userLocation
        return userLocation.distanceFromLocation(location)/1000
    }
}