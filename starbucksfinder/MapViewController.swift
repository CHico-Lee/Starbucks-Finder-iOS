//
//  MapViewController.swift
//  starbucksfinder
//
//  Created by CHico on 5/13/18.
//  Copyright © 2018 CHico. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var name = "No result"
    var lat: Double = 0.0
    var lng: Double = 0.0
    var vicinity = ""
    var store : Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let store = store{
            name = store.name
            vicinity = store.vicinity
            lat = store.lat
            lng = store.lng
        }
        loadMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMap() {
        // Create a GMSCameraPosition that tells the map to display
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.title = name
        marker.snippet = vicinity
        marker.map = mapView
    }
}

