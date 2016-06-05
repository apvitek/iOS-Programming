//
//  MapViewController.swift
//  RestaurantsApp
//
//  Created by Andrea Borghi on 11/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var userLocation: CLLocation {
        return (UIApplication.sharedApplication().delegate as AppDelegate).userLocation
    }
    var annotations: [AnyObject]?
    var routeOverlays = [MKPolyline]()
    var currentRoute: MKRoute?
    let reuseID = "RestaurantAnnotationView"
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        mapView.delegate = self
        
        if (annotations != nil) {
            mapView.addAnnotations(annotations)
            
            if let annotationToSelect = annotations?.first as? MKAnnotation {
                if annotations?.count == 1 {
                    mapView.selectAnnotation(annotationToSelect, animated: false)
                }
            }
            
            mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    @IBAction func centerOnUserLocationButtonPressed(sender: AnyObject) {
        if mapView.selectedAnnotations != nil {
            var selectedView = mapView.selectedAnnotations.first as MKAnnotation
            var mapSpan = MKCoordinateSpanMake((userLocation.coordinate.latitude - selectedView.coordinate.latitude), userLocation.coordinate.longitude + selectedView.coordinate.longitude)
            let midpoint = CLLocationCoordinate2DMake((userLocation.coordinate.latitude + selectedView.coordinate.latitude) / 2, (userLocation.coordinate.longitude + selectedView.coordinate.longitude) / 2)
            let viewRegion = MKCoordinateRegionMake(midpoint, MKCoordinateSpanMake(0.05, 0.05))
            mapView.setRegion(viewRegion, animated: true)
        } else {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            mapView.setRegion(adjustedRegion, animated: true)
        }
    }
    
    @IBAction func redoSearchButtonPressed(sender: AnyObject) {
        //To calculate the search bounds...
        //First we need to calculate the corners of the map so we get the points
        var nePoint = CGPointMake(self.mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y)
        var swPoint = CGPointMake((self.mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height))
        
        //Then transform those point into lat,lng values
        var neCoord: CLLocationCoordinate2D
        neCoord = mapView.convertPoint(nePoint, toCoordinateFromView: mapView)
        
        var swCoord: CLLocationCoordinate2D
        swCoord = mapView.convertPoint(swPoint, toCoordinateFromView: mapView)
        
        var newCoordinate: CLLocationCoordinate2D
        newCoordinate = CLLocationCoordinate2DMake((neCoord.latitude + swCoord.latitude) / 2, (neCoord.longitude + swCoord.longitude) / 2)
        
        var newCoordinatesForSearch:CLLocation = CLLocation(latitude: mapView.visibleMapRect.origin.x, longitude: mapView.visibleMapRect.origin.y)
        Restaurant.populateDatabaseWithRestaurants(CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude), context: (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            view.canShowCallout = true
            let disclosureButton = UIButton(frame: CGRectMake(0, 0, 46, 46))
            disclosureButton.backgroundColor = UIColor.blueColor()
            disclosureButton.setBackgroundImage(UIImage(named: "route"), forState: .Normal)
            view.leftCalloutAccessoryView = disclosureButton
        }
        
        view.annotation = annotation
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        activityIndicator.frame = view.leftCalloutAccessoryView.frame
        view.leftCalloutAccessoryView.addSubview(activityIndicator)
        getDirectionsToRestaurant()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
    
    func getDirectionsToRestaurant() {
        activityIndicator.startAnimating()
        var request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        let destination = mapView.selectedAnnotations.first as MKAnnotation
        request.setDestination(MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil)))
        request.requestsAlternateRoutes = true
        var directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!, error: NSError!) -> Void in
            if error == nil {
                self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first as MKAnnotation, animated: true)
                self.plotRouteOnMap(Array(arrayLiteral: response.routes[0] as MKRoute))
                // Multiple routes
                //self.plotRouteOnMap(response.routes as [MKRoute])
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func plotRouteOnMap(routes: [MKRoute]) {
        if routeOverlays.isEmpty == false {
            for overlay in routeOverlays {
                mapView.removeOverlay(overlay)
            }
            routeOverlays.removeAll(keepCapacity: true)
        }
        
        var longest = routes.first
        
        for route in routes {
            routeOverlays.append(route.polyline)
            mapView.addOverlay(route.polyline)
            
            if route.distance > longest?.distance {
                longest = route
            }
        }
        
        var mapRect = longest!.polyline.boundingMapRect
        var expandedRect = MKMapRectInset(mapRect, -1500, -1500)
        self.mapView.setVisibleMapRect(expandedRect, animated: true)
        
        UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: { () -> Void in
            self.title = String(format: "%.1f minutes away", longest!.expectedTravelTime / 60)
        }, completion: nil)
    }
}
