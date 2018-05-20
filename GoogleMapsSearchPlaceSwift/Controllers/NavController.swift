//
//  NavController.swift
//  GoogleMapsSearchPlaceSwift
//
//  Created by Максим Атюцкий on 20.05.2018.
//  Copyright © 2018 Максим Атюцкий. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    var placeController: PlaceController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewController {
            viewController.placeController = placeController
        }
    }

    /*
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
