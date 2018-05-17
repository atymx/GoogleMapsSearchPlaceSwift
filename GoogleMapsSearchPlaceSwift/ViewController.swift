//
//  ViewController.swift
//  GoogleMapsSearchPlaceSwift
//
//  Created by Максим Атюцкий on 18.05.2018.
//  Copyright © 2018 Максим Атюцкий. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, UISearchDisplayDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var MapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        let (latitude, longitude) = (self.locationManager.location?.coordinate.latitude, self.locationManager.location?.coordinate.latitude)
        self.LoadMap(latitude: latitude!, longitude: longitude!, title: "You are here")
    }
    
    func LoadMap(latitude: Double, longitude: Double, title: String) {
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 6.0)
        MapView.isMyLocationEnabled = true
        MapView.camera = camera
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.map = MapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

