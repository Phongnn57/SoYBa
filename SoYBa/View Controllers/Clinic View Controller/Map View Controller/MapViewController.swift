//
//  MapViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var clinics: [Clinic]!
    var locationManager: CLLocationManager!
    var initialLocation: CLLocation!
    var regionRadius: CLLocationDistance = 1000
    var showOnePlace: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavigationBarWithTitle("Danh sách nhà thuốc")
        self.configNavigation()
        self.clinics = Clinic.MR_findAll() as! [Clinic]

        if self.initialLocation == nil {
            self.initialLocation = CLLocation(latitude: 21.0277644, longitude: 105.8341598)
        }
        
        if self.showOnePlace {
            self.regionRadius = 50
            self.centerMapOnLocation(self.initialLocation)
        } else {
            self.regionRadius = 1000
            self.centerMapOnLocation(self.initialLocation)
        }
        
        self.pinClinicIntoMap()
        
//        self.locationManager = CLLocationManager()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
//        self.checkLocationAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.mapview.setRegion(coordinateRegion, animated: true)
    }
    
    func configNavigation() {
        let btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btn.setImage(UIImage(named: "back"), forState: .Normal)
        btn.frame = CGRectMake(0, 0, 14, 22)
        btn.addTarget(self, action: "backToParentView", forControlEvents: UIControlEvents.TouchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    func pinClinicIntoMap() {
        for clinic in self.clinics {
            var annotation = SkyDanceAnnotation(coordinate: CLLocationCoordinate2D(latitude: clinic.longitude.doubleValue, longitude: clinic.latitude.doubleValue), title: clinic.name, subtitle: clinic.address)
            self.mapview.addAnnotation(annotation)
        }
    }
    
    // MARK: MAPVIEW METHODS
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        var region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)
//        mapView.setRegion(self.mapview.regionThatFits(region), animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if annotation.isKindOfClass(MKUserLocation) {
//            return nil
//        }
        
        let annotationIdentifier = "annotationIdentifier"
        var annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView.image = UIImage(named: "annotation")
        annotationView.canShowCallout = true
        
        return annotationView
    }
    

    
    // MARK: BUTTON ACTION
    func backToParentView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


}
