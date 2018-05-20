//
//  SearchVC.swift
//  GoogleMapsSearchPlaceSwift
//
//  Created by Максим Атюцкий on 20.05.2018.
//  Copyright © 2018 Максим Атюцкий. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire

class SearchVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var searchResult: [String] = []
    
    var placeController: PlaceController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchBar.delegate = self
        SearchBar.becomeFirstResponder()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = []
        
        let parameters: Parameters = [
            "geocode": searchText,
            "format": "json",
            "lang": "en_US"
        ]
        Alamofire.request(Config.shared.YandexGeocoderApiUrl, parameters: parameters).responseJSON { response in
            if let json = try? JSON(data: response.data!) {
                var searchBufResult: [String] = []
                let count = json["response"]["GeoObjectCollection"]["featureMember"].array?.count
                for index in 0..<count! {
                    searchBufResult.append(json["response"]["GeoObjectCollection"]["featureMember"][index]["GeoObject"]["metaDataProperty"]["GeocoderMetaData"]["text"].stringValue)
                }
                self.searchResult = searchBufResult
                self.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "address", for: indexPath)
        
        cell.textLabel?.text = searchResult[indexPath[1]]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = searchResult[indexPath[1]]
        
        let parameters: Parameters = [
            "geocode": selectedAddress,
            "format": "json",
            "lang": "en_US"
        ]
        
        Alamofire.request(Config.shared.YandexGeocoderApiUrl, parameters: parameters).responseJSON { response in
            if let json = try? JSON(data: response.data!) {
                if let coordinates = json["response"]["GeoObjectCollection"]["featureMember"][0]["GeoObject"]["boundedBy"]["Envelope"]["lowerCorner"].string {
                    let (longitude, latitude) = (CLLocationDegrees(coordinates.split(separator: " ")[0]),
                                                 CLLocationDegrees(coordinates.split(separator: " ")[1]))
                    self.placeController?.place = Place(address: selectedAddress, longitude: longitude, latitude: latitude)
                    self.dismiss(animated: false)
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
