//
//  RestaurantListResponse.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//

import Foundation

struct RestaurantListResponse: Decodable {
    let sections: [Section]
}

struct Section: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let venue: Venue
    let image: Image
}

struct Image: Decodable {
    let url: String
}

struct Venue: Decodable {
    let name: String
    let id: String
    let shortDescription: String
}
