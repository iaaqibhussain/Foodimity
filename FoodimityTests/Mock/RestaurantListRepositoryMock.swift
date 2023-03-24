//
//  RestaurantListRepositoryMock.swift
//  FoodimityTests
//
//  Created by Syed Muhammad Aaqib Hussain on 21.03.23.
//

import Foundation
@testable import Foodimity

class RestaurantListRepositoryMock: RestaurantListRepository {
    var fetchRestaurantListCallsCount = 0
    var fetchRestaurantListArgs: [(coordinate: Coordinate, completionHandler: RestaurantListCompletion)] = []
    var fetchRestaurantListClosure: ((Coordinate, @escaping RestaurantListCompletion) -> Void)?
    
    var restaurantMarkedFavoriteCallsCount = 0
    var restaurantMarkedFavoriteArgs: [String] = []
    var restaurantMarkedFavoriteClosure: ((String) -> Void)?
    
    var removeMarkedFavoriteRestaurantCallsCount = 0
    var removeMarkedFavoriteRestaurantArgs: [String] = []
    var removeMarkedFavoriteRestaurantClosure: ((String) -> Void)?
    
    var getMarkedFavoriteRestaurantsCallsCount = 0
    var getMarkedFavoriteRestaurantsReturnValue: Set<String> = []
    var getMarkedFavoriteRestaurantsClosure: (() -> Set<String>)?
    
    func fetchRestaurantList(
        with coordinate: Coordinate,
        completionHandler: @escaping RestaurantListCompletion
    ) {
        fetchRestaurantListCallsCount += 1
        fetchRestaurantListArgs.append((coordinate, completionHandler))
        fetchRestaurantListClosure?(coordinate, completionHandler)
    }
    
    func restaurantMarkedFavorite(for id: String) {
        restaurantMarkedFavoriteCallsCount += 1
        restaurantMarkedFavoriteArgs.append(id)
        restaurantMarkedFavoriteClosure?(id)
    }
    
    func removeMarkedFavoriteRestaurant(for id: String) {
        removeMarkedFavoriteRestaurantCallsCount += 1
        removeMarkedFavoriteRestaurantArgs.append(id)
        removeMarkedFavoriteRestaurantClosure?(id)
    }
    
    func getMarkedFavoriteRestaurants() -> Set<String> {
        getMarkedFavoriteRestaurantsCallsCount += 1
        return getMarkedFavoriteRestaurantsClosure.map { $0() } ?? getMarkedFavoriteRestaurantsReturnValue
    }
}
