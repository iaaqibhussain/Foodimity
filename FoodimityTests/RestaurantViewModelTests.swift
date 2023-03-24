//
//  RestaurantViewModelTests.swift
//  FoodimityTests
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//

import XCTest
@testable import Foodimity

final class RestaurantViewModelTests: XCTestCase {
    var viewModel: RestaurantListViewModel!
    
    var repository: RestaurantListRepositoryMock!
    var mapper: RestaurantViewDataMapperMock!
    var timeManager: TimerManagerMock!
    
    override func setUp() {
        super.setUp()
        repository = RestaurantListRepositoryMock()
        mapper = RestaurantViewDataMapperMock()
        timeManager = TimerManagerMock()
        
        viewModel = RestaurantListViewModel(
            repository: repository,
            mapper: mapper,
            timerManager: timeManager
        )
        
    }
    
    func testOnViewDidLoad_Success() throws {
        repository.fetchRestaurantListClosure = { _, completion in
            completion(.success(RestaurantListResponse(sections: [])))
        }
        
        viewModel.onViewDidLoad()
        
        
        XCTAssertEqual(repository.fetchRestaurantListCallsCount, 1)
        XCTAssertEqual(mapper.mapCallsCount, 1)
        XCTAssertEqual(timeManager.scheduleTimerCallsCount, 1)
    }
    
    func testOnViewDidLoad_Fail() throws {
        let expectation = expectation(description: "This should fail the test and error block should be called")
        repository.fetchRestaurantListClosure = { _, completion in
            completion(.failure(.invalidServerResponse))
        }
        
        viewModel.onStateChange = { state in
            switch state {
            case .error:
                expectation.fulfill()
            case .loading, .update, .finished:
                break
            }
        }
        
        viewModel.onViewDidLoad()
        
        wait(for: [expectation], timeout: 0.2)
    
        XCTAssertEqual(repository.fetchRestaurantListCallsCount, 1)
        XCTAssertEqual(mapper.mapCallsCount, 0)
        XCTAssertEqual(timeManager.scheduleTimerCallsCount, 1)
    }
    
    func testNumberOfRows() throws {
        let expectedCount = 3
        
        setupSuccessData()
        
        viewModel.onViewDidLoad()
        
        let numberOfRows = viewModel.numberOfRows
        XCTAssertEqual(numberOfRows, expectedCount)
    }
    
    func testRestaurantMarkedFavorite() throws {
        setupSuccessData()
        
        viewModel.onViewDidLoad()
        
        mapper.mapViewDataForState = getRestaurantViewData(isFavorite: true)
        viewModel.restaurantMarked(with: true, at: 0)
        
        XCTAssertEqual(repository.restaurantMarkedFavoriteCallsCount, 1)
        XCTAssertEqual(repository.removeMarkedFavoriteRestaurantCallsCount, 0)
    }
    
    func testRestaurantMarkedUnFavorite() throws {
        setupSuccessData()
        
        viewModel.onViewDidLoad()
        
        mapper.mapViewDataForState = getRestaurantViewData(isFavorite: false)
        viewModel.restaurantMarked(with: false, at: 0)
        
        XCTAssertEqual(repository.removeMarkedFavoriteRestaurantCallsCount, 1)
        XCTAssertEqual(repository.restaurantMarkedFavoriteCallsCount, 0)
    }
}

private extension RestaurantViewModelTests {
    func setupSuccessData() {
        repository.fetchRestaurantListClosure = { _, completion in
            completion(.success(RestaurantListResponse(sections: [])))
        }
        
        mapper.mappedData = [
            RestaurantViewData(name: "Restaurant 1", id: "1", shortDescription: "", imageURLString: "", isFavorite: false),
            RestaurantViewData(name: "Restaurant 2", id: "2", shortDescription: "", imageURLString: "", isFavorite: false),
            RestaurantViewData(name: "Restaurant 3", id: "3", shortDescription: "", imageURLString: "", isFavorite: false)
        ]
    }
    
    func getRestaurantViewData(
        name: String =  "Restaurant 1",
        id: String = "",
        shortDescription: String = "",
        imageURLString: String = "",
        isFavorite: Bool
    ) -> RestaurantViewData {
        RestaurantViewData(
            name: name,
            id: id,
            shortDescription: shortDescription,
            imageURLString: imageURLString,
            isFavorite: isFavorite
        )
    }
}
