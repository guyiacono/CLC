//
//  EventMapViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/19/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventMapViewController: UIViewController, CLLocationManagerDelegate {
let annotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
        map.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
