//
//  RestaurantsApp.swift
//  RestaurantsApp
//
//  Created by Andrea Borghi on 11/29/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Restaurant: NSManagedObject {
    @NSManaged var address: String
    @NSManaged var distance: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    
    var location: CLLocation {
        return CLLocation(latitude: latitude as Double, longitude: longitude as Double)
    }
}
