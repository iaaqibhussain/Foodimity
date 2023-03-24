//
//  Coordinate.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 20.03.23.
//

import Foundation

struct Coordinate {
    let lat: Double
    let long: Double
    
    var params: [String : String] {
        [
            "lat" : "\(lat)",
            "lon" : "\(long)"
        ]
    }
}
