//
//  RestaurantViewData.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 21.03.23.
//

import Foundation

struct RestaurantViewData {
    let name: String
    let id: String
    let shortDescription: String
    let imageURLString: String
    let isFavorite: Bool
    
    var imageURL: URL {
        URL(string: imageURLString)!
    }
}
