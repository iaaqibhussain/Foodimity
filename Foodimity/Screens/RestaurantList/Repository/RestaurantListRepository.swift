//
//  RestaurantListRepository.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 20.03.23.
//

import Foundation

typealias RestaurantListCompletion = (Result<RestaurantListResponse, NetworkError>) -> ()

protocol RestaurantListRepository {
    func fetchRestaurantList(
        with coordinate: Coordinate,
        completionHandler: @escaping RestaurantListCompletion
    )
    
    func restaurantMarkedFavorite(for id: String)
    func removeMarkedFavoriteRestaurant(for id: String)
    
    func getMarkedFavoriteRestaurants() -> Set<String>
}

final class RestaurantListRepositoryImpl: RestaurantListRepository {
    private let networkManager: NetworkManager
    private let userDefaults: UserDefaults
    private let key = "favorite_ids"
    init(
        networkManager: NetworkManager = NetworkManagerImpl(),
        userDefaults: UserDefaults = .standard
    ) {
        self.networkManager = networkManager
        self.userDefaults = userDefaults
    }
    
    func fetchRestaurantList(
        with coordinate: Coordinate,
        completionHandler: @escaping RestaurantListCompletion
    ) {
        do {
            try fetch(
                with: coordinate,
                completionHandler: completionHandler
            )
        } catch {
            completionHandler(.failure(.error(error)))
        }
    }
    
    func restaurantMarkedFavorite(for id: String) {
        var ids: [String] = []
        if let savedIds = userDefaults.stringArray(forKey: key) {
            ids = savedIds
        }
        ids.append(id)
        userDefaults.set(ids, forKey: key)
    }
    
    func removeMarkedFavoriteRestaurant(for id: String) {
        if let savedIds = userDefaults.stringArray(forKey: key) {
            var ids = Set(savedIds)
            ids.remove(id)
            userDefaults.set(Array(ids), forKey: key)
        }
    }
    
    func getMarkedFavoriteRestaurants() -> Set<String> {
        let ids = userDefaults.stringArray(forKey: key) ?? []
        return Set(ids)
    }
}

private extension RestaurantListRepositoryImpl {
    func fetch(
        with coordinate: Coordinate,
        completionHandler: @escaping RestaurantListCompletion
    ) throws {
        let request = RestaurantListRequest(coordinate: coordinate)
        try networkManager.execute(request: request, completion: completionHandler)
    }
}
