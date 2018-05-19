//
//  NearbyStarbucks.swift
//  starbucksfinder
//
//  Created by CHico on 5/15/18.
//  Copyright © 2018 CHico. All rights reserved.
//

import Foundation

class NearbyStarbucks {
    static let sharedInstance = NearbyStarbucks()
    
    var stores : [Store]
    private init () {
        self.stores = [Store]()
    }
}
