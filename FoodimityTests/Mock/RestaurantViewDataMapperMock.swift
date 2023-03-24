//
//  RestaurantViewDataMapperMock.swift
//  FoodimityTests
//
//  Created by Syed Muhammad Aaqib Hussain on 21.03.23.
//

import Foundation
@testable import Foodimity

final class RestaurantViewDataMapperMock: RestaurantViewDataMapper {
    var mapCallsCount = 0
    var mappedData: [RestaurantViewData]?
    
    var mapViewDataForStateCallsCount = 0
    var mapViewDataForState: RestaurantViewData!
    
    var sections: [Section]?
    
    var areRestaurantsMarkedFavorite: Set<String>?
    
    func map(
        _ sections: [Section],
        areRestaurantsMarkedFavorite: Set<String>
    ) -> [RestaurantViewData] {
        mapCallsCount += 1
        self.sections = sections
        self.areRestaurantsMarkedFavorite = areRestaurantsMarkedFavorite
        return mappedData ?? []
    }
    
    func map(_ viewData: RestaurantViewData, for state: Bool) -> RestaurantViewData {
        mapViewDataForStateCallsCount += 1
        return mapViewDataForState
    }
}
