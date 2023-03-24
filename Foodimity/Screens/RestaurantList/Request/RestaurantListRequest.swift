//
//  RestaurantListRequest.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//

import Foundation

final class RestaurantListRequest: Request {
    var queryParams: [String : String]
    
    var path: String {
        "RestaurantList"
    }
    
    init(coordinate: Coordinate) {
        self.queryParams = coordinate.params
    }
    
    var readFromLocal: Bool {
        true
    }
}
