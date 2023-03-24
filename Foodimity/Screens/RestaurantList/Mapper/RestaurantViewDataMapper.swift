//
//  RestaurantViewDataMapper.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 20.03.23.
//

import Foundation

protocol RestaurantViewDataMapper {
    func map(
        _ sections: [Section],
        areRestaurantsMarkedFavorite: Set<String>
    ) -> [RestaurantViewData]
    
    func map(
        _ viewData: RestaurantViewData,
        for state: Bool
    ) -> RestaurantViewData
}

final class RestaurantViewDataMapperImpl: RestaurantViewDataMapper {
    func map(
        _ sections: [Section],
        areRestaurantsMarkedFavorite: Set<String>
    ) -> [RestaurantViewData] {        
        let items: [[Item]] = sections.map { section in
            section.items.count > 15 ? Array(section.items[0...14]) : section.items
        }

//        let venueItems = items.filter { !$0.contains(where: { $0.venue == nil }) }

        let restaurantViewDataArray = items.flatMap { $0 }.map {
            RestaurantViewData(
                name: $0.venue.name,
                id: $0.venue.id,
                shortDescription: $0.venue.shortDescription,
                imageURLString: $0.image.url,
                isFavorite: areRestaurantsMarkedFavorite.contains($0.venue.id)
            )
        }

        return restaurantViewDataArray

    }
    
    func map(
        _ viewData: RestaurantViewData,
        for state: Bool
    ) -> RestaurantViewData {
        RestaurantViewData(
            name: viewData.name,
            id: viewData.id,
            shortDescription: viewData.shortDescription,
            imageURLString: viewData.imageURLString,
            isFavorite: state
        )
    }
}
