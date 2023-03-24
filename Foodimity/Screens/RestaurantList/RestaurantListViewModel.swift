//
//  RestaurantListViewModel.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 20.03.23.
//

import Foundation

enum RestaurantListState {
    case loading
    case update
    case finished
    case error(String)
}

final class RestaurantListViewModel {
    private let repository: RestaurantListRepository
    private let mapper: RestaurantViewDataMapper
    private let coordinates = [
        Coordinate(lat: 60.170187, long: 24.930599),
        Coordinate(lat: 60.169418, long: 24.931618),
        Coordinate(lat: 60.169818, long: 24.932906),
        Coordinate(lat: 60.170005, long: 24.935105),
        Coordinate(lat: 60.169108, long: 24.936210),
        Coordinate(lat: 60.168355, long: 24.934869),
        Coordinate(lat: 60.167560, long: 24.932562),
        Coordinate(lat: 60.168254, long: 24.931532),
        Coordinate(lat: 60.169012, long: 24.930341),
        Coordinate(lat: 60.170085, long: 24.929569)
    ]
    private let timerManager: TimerManager
    private var fetchCounter = 0
    private var restaurants: [RestaurantViewData] = []
    
    var onStateChange: ((RestaurantListState) -> ())?
    
    var numberOfRows: Int {
        restaurants.count
    }
    
    init(
        repository: RestaurantListRepository = RestaurantListRepositoryImpl(),
        mapper: RestaurantViewDataMapper = RestaurantViewDataMapperImpl(),
        timerManager: TimerManager = TimerManagerImpl(timeInterval: 10, repeats: true)
    ) {
        self.repository = repository
        self.mapper = mapper
        self.timerManager = timerManager
    }
    
    func onViewDidLoad() {
        fetchRestaurantList(coordinate: coordinates[fetchCounter])
        timerManager.scheduleTimer { [weak self] in
            self?.refetch()
        }
    }
    
    func restaurantMarked(
        with state: Bool,
        at index: Int
    ) {
        let viewData = restaurants[index]
        let id = viewData.id
        
        state ? repository.restaurantMarkedFavorite(for: id) : repository.removeMarkedFavoriteRestaurant(for: id)
        
        restaurants[index] = mapper.map(
            viewData,
            for: state
        )
    }
    
    func getItemAt(index: Int) -> RestaurantViewData {
        restaurants[index]
    }
    
    deinit {
        timerManager.stop()
    }
}

private extension RestaurantListViewModel {
    func fetchRestaurantList(coordinate: Coordinate) {
        onStateChange?(.loading)
        repository.fetchRestaurantList(with: coordinate) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.restaurants = self.mapper.map(
                    data.sections,
                    areRestaurantsMarkedFavorite: self.repository.getMarkedFavoriteRestaurants()
                )
                self.onStateChange?(.update)
                self.onStateChange?(.finished)
            case let .failure(error):
                self.onStateChange?(.error(error.localizedDescription))
                self.onStateChange?(.finished)
            }
        }
    }
    
    func refetch() {
        fetchCounter += 1
        
        if fetchCounter >= coordinates.count {
            fetchCounter = 0
        }
        
        fetchRestaurantList(coordinate: coordinates[fetchCounter])
    }
}
