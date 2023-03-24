//
//  TimerManagerMock.swift
//  FoodimityTests
//
//  Created by Syed Muhammad Aaqib Hussain on 21.03.23.
//

import Foundation
@testable import Foodimity

final class TimerManagerMock: TimerManager {
    var scheduleTimerCallsCount = 0
    
    var stopCallsCount = 0
    
    func scheduleTimer(_ completionHandler: @escaping CompletionHandler) {
        scheduleTimerCallsCount += 1
    }
    
    func stop() {
        stopCallsCount += 1
    }
}
