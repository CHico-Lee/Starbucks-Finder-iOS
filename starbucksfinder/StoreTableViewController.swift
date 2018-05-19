//
//  StoreTableViewController.swift
//  starbucksfinder
//
//  Created by CHico on 5/15/18.
//  Copyright © 2018 CHico. All rights reserved.
//

import UIKit
import CoreLocation
import os.log
import GooglePlacePicker

class StoreTableViewController: UITableViewController, CLLocationManagerDelegate, GMSPlacePickerViewControllerDelegate {
    
    //MARK: Properties

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let locationManager = CLLocationManager()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NearbyStarbucks.sharedInstance.stores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StoreTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StoreTableViewCell else {
            fatalError("The dequeued cell is not an instance of StoreTableViewCell.")
        }

        // Configure the cell...
        let store = NearbyStarbucks.sharedInstance.stores[indexPath.row]
        cell.nameLabel.text = store.name + "\n" + store.vicinity
        cell.openNowLabel.text = "Unknown"
        if let isOpen = store.openNow {
            cell.openNowLabel.text = isOpen ? "Open" : "Closed"
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowMap":
            guard let detailViewController = segue.destination as? MapViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? StoreTableViewCell else {
                fatalError("Unexpected sender: \(sender!)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedStore = NearbyStarbucks.sharedInstance.stores[indexPath.row]
            detailViewController.store = selectedStore
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
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
    
    @IBAction func changeLocation(_ sender: Any) {
    
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        let latLong = (place.coordinate.latitude, place.coordinate.longitude)
        loadStarbucksJson(latLong)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latLong = (locValue.latitude, locValue.longitude)
        if (!isLoading && NearbyStarbucks.sharedInstance.stores.isEmpty) {
            loadStarbucksJson(latLong)
        }
    }
    
    func loadStarbucksJson(_ latLong:(Double,Double)) {
        isLoading = true
        NearbyStarbucks.sharedInstance.stores.removeAll()
        tableView.reloadData()
        activityIndicator.startAnimating()
        
        var keys : NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        var apiKey : String = ""
        if let dict = keys {
            apiKey = dict["webPlacesApiKey"]! as! String
        }
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLong.0),\(latLong.1)&rankby=distance&type=cafe&keyword=Starbucks&key=\(apiKey)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let json = jsonSerialized, let results = json["results"] {
                        
                        for result in (results as! NSArray as! [NSDictionary]) {
                            if let geometry = result["geometry"] as! NSDictionary?, let location = geometry["location"] as! NSDictionary? {
                                let name = result["name"] as! String
                                let vicinity = result["vicinity"] as! String
                                let lat = location["lat"] as! Double
                                let lng = location["lng"] as! Double
                                var openNow : Bool? = nil
                                if let opening = result["opening_hours"] as! NSDictionary?{
                                    if let opened = opening["open_now"] as! Bool? {
                                        openNow = opened
                                    }
                                }
                                let newStore = Store(name: name, vicinity: vicinity, lat: lat, lng: lng, openNow: openNow)
                                NearbyStarbucks.sharedInstance.stores += [newStore]
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            } else if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "Could not load data", message: "Please connect to the Internet.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.loadStarbucksJson(latLong)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            self.postLoadStoreJson()
        }
        task.resume()
    }
    
    func postLoadStoreJson() {
        isLoading=false
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
}

