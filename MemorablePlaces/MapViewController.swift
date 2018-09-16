//
//  MapViewController.swift
//  MemorablePlaces
//
//  Created by Charles Martin Reed on 9/15/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- User location information
    var userLocationCoordinates = CLLocationCoordinate2D()
    var userLocationTitle = ""
    var userLocationSubtitle = ""
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        //MARK:- Location manager setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //MARK:- Dummy data map setup
        //set up the map for the first bit of data, Tower Bridge in London
//        let lat: CLLocationDegrees = 51.505153
//        let long: CLLocationDegrees = -0.075664
//
//        let latDelta: CLLocationDegrees = 0.05
//        let longDelta: CLLocationDegrees = 0.05
//
//        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
//
//        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//
//        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
//
//        mapView.setRegion(region, animated: true)
        
        //MARK:- Dummy data annotation setup
//        let annotation = MKPointAnnotation()
//        annotation.title = "Tower Bridge"
//        annotation.subtitle = "Contrary to popular belief, the bridge is not falling down."
//        annotation.coordinate = location
//
//        mapView.addAnnotation(annotation)
        
    }
    
    //MARK:- Grabbing the location the user touched and placing a pin there
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //if there's a location to grab, grab the first one
        let userLocation = locations[0]
        
        //build and show the map in the view
        makeMap(lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                //update the user variables
                guard let placemark = placemarks?[0] else { return }
                
                if let thoroughfare = placemark.thoroughfare {
                    if let subthoroughfare = placemark.subThoroughfare {
                        self.userLocationTitle = subthoroughfare + " " + thoroughfare
                    }
                }
                
                if let sublocality = placemark.subLocality {
                    self.userLocationSubtitle = sublocality
                }
                
                //MARK:- User created annotation setup
                let longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.placeAnnotation(_:)))
                longPressRecognizer.minimumPressDuration = 1
                self.mapView.addGestureRecognizer(longPressRecognizer)
                
            }
        }
    }
    
    @objc func placeAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
        //grab the location from where the user long-pressed
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        
        //conver the touch point into a location
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        //create the annotation, per usual
        let userAnnotation = MKPointAnnotation()
        
        userAnnotation.coordinate = coordinate
        userAnnotation.title = userLocationTitle
        userAnnotation.subtitle = userLocationSubtitle
        mapView.addAnnotation(userAnnotation)
    }
    
    @objc func makeMap(lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        //MARK:- User location map setup
        //set up the map for the first bit of data, Tower Bridge in London
        
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        //put an annotation denoting where the user is
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "You are here."
        annotation.subtitle = "Creepy, no?"
        
        mapView.addAnnotation(annotation)
        
        
    }
    
    @objc func saveLocation(latitude lat: CLLocationDegrees, longitude long: CLLocationDegrees) {
        
        //take the user location and lat and store them
        UserDefaults.standard.set(lat, forKey: "userLat")
        UserDefaults.standard.set(long, forKey: "userLong")
        
    }
    
    
}
