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
import SWMessages

class ViewController: UIViewController, UISearchDisplayDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var MapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        // Get current coordinates
        let (longitude, latitude) = (self.locationManager.location?.coordinate.longitude, self.locationManager.location?.coordinate.latitude)
        setCurrentLocation(longitude: longitude, latitude: latitude)
        
    }
    
    func setCurrentLocation(longitude: CLLocationDegrees?, latitude: CLLocationDegrees?) {
        if latitude != nil && longitude != nil {
            let parameters: Parameters = [
                "geocode": (String(longitude!) + "," + String(latitude!)),
                "format": "json",
                "lang": "en_US"
            ]
            Alamofire.request(Config.shared.YandexGeocoderApiUrl, parameters: parameters).responseJSON { response in
                if let json: Parameters = (response.value! as! Parameters)["response"] as? Parameters {
                    if let objects = (json["GeoObjectCollection"] as! Parameters)["featureMember"] as? [[String: Any]] {
                        let firstObject = objects[0]["GeoObject"] as? [String: Any]
                        if let title = ((firstObject!["metaDataProperty"] as! [String: Any])["GeocoderMetaData"] as! [String: Any])["text"] {
                            self.SearchBar.placeholder = title as? String
                            self.LoadMap(longitude: longitude, latitude: latitude, title: title as? String)
                        }
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

}

