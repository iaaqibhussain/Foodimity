//
//  TimerManager.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 20.03.23.
//

import Foundation

typealias CompletionHandler = () -> Void

protocol TimerManager {
    func scheduleTimer(_ completionHandler: @escaping CompletionHandler)
    func stop()
}

final class TimerManagerImpl: TimerManager {
    private var timer: Timer? = nil
    private var completionHandler: CompletionHandler? = nil
    private let timeInterval: TimeInterval
    private let repeats: Bool
    
    init(
        timeInterval: TimeInterval,
        repeats: Bool
    ) {
        self.timeInterval = timeInterval
        self.repeats = repeats
    }
    
    func scheduleTimer(_ completionHandler: @escaping CompletionHandler) {
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: repeats,
            block: { _ in
            completionHandler()
        })
    }
    
    func stop() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }
}

