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
import Alamofire
import SwiftyJSON

class MainVC: UIViewController, UISearchDisplayDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var MapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    var placeController: PlaceController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Delete line bellow Nav Bar
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Make an instance of PlaceController class
        if placeController == nil {
            placeController = PlaceController()
        }
        
        // Get current coordinates
        let (longitude, latitude) = (self.locationManager.location?.coordinate.longitude, self.locationManager.location?.coordinate.latitude)
        
        let place = placeController?.place

        if place?.address == nil || place?.longitude == nil || place?.latitude == nil {
            self.setCurrentLocation(longitude: longitude, latitude: latitude)
        } else {
            self.SearchBar.placeholder = place?.address
            self.LoadMap(longitude: place?.longitude, latitude: place?.latitude, title: place?.address)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCurrentLocation(longitude: CLLocationDegrees?, latitude: CLLocationDegrees?) {
        if latitude != nil && longitude != nil {
            let parameters: Parameters = [
                "geocode": (String(longitude!) + "," + String(latitude!)),
                "format": "json",
                "lang": "en_US"
            ]
            Alamofire.request(Config.shared.YandexGeocoderApiUrl, parameters: parameters).responseJSON { response in
                if let json = try? JSON(data: response.data!) {
                    if let currentAddress = json["response"]["GeoObjectCollection"]["featureMember"][0]["GeoObject"]["metaDataProperty"]["GeocoderMetaData"]["text"].string {
                        self.placeController?.place = Place.init(address: currentAddress, longitude: longitude, latitude: latitude)
                        self.SearchBar.placeholder = currentAddress
                        self.LoadMap(longitude: longitude, latitude: latitude, title: currentAddress)
                    }
                }
            }
        }
    }
    
    func LoadMap(longitude: CLLocationDegrees?, latitude: CLLocationDegrees?, title: String?) {
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 13)
        MapView.isMyLocationEnabled = true
        MapView.camera = camera
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.title = title!
        marker.map = MapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.placeController = placeController
        }
    }

}

