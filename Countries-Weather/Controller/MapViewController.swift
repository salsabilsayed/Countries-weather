//
//  MapViewController.swift
//  Countries-Weather
//
//  Created by ifts 25 on 23/04/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var recievedCoordinates: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: recievedCoordinates[0], longitude: recievedCoordinates[1])
        setStartingLocation(location: initialLocation, distance: 250000)
        
    }
    
    func setStartingLocation(location: CLLocation, distance: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }

}

