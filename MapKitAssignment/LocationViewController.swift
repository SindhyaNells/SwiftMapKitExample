//
//  LocationViewController.swift
//  MapKitAssignment
//
//  Created by Sindhya on 9/25/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    
    @IBOutlet weak var txtFromAddr: UITextField!
    @IBOutlet weak var txtFromCity: UITextField!
    @IBOutlet weak var txtFromState: UITextField!
    @IBOutlet weak var txtFromZipcode: UITextField!
    
    @IBOutlet weak var txtToAddr: UITextField!
    @IBOutlet weak var txtToCity: UITextField!
    @IBOutlet weak var txtToState: UITextField!
    @IBOutlet weak var txtToZipcode: UITextField!
    
    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var routeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtFromAddr.text = "130 E San Fernando St"
        txtFromCity.text = "San Jose"
        txtFromState.text = "California"
        txtFromZipcode.text = "95112"
        
        txtToAddr.text = "10081 Carmen Road"
        txtToCity.text = "Cupertino"
        txtToState.text = "California"
        txtToZipcode.text = "95014"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fromLocation = txtFromAddr.text! + ", " + txtFromCity.text! + ", " + txtFromState.text! + ", " + txtFromZipcode.text! + ", USA"
        let toLocation = txtToAddr.text! + ", " + txtToCity.text! + ", " + txtFromState.text! + ", " + txtToZipcode.text! + ", USA"
        
        if let destViewController = segue.destination as? MapViewController {
            destViewController.fromLocation = fromLocation
            destViewController.toLocation = toLocation
            if segue.identifier == "viewMap" {
                destViewController.viewType = "map"
            } else if segue.identifier == "viewRoute" {
                destViewController.viewType = "route"
            }
        }
    }
    
}

