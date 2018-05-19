//
//  Store.swift
//  starbucksfinder
//
//  Created by CHico on 5/14/18.
//  Copyright © 2018 CHico. All rights reserved.
//

import UIKit

class Store {
    //MARK: Properties
    var name: String
    var vicinity: String
    var lat: Double
    var lng: Double
    var openNow: Bool?
    
    init (name: String, vicinity: String, lat: Double, lng: Double, openNow: Bool?) {
        self.name = name
        self.vicinity = vicinity
        self.lat = lat
        self.lng = lng
        self.openNow = openNow
    }
}
