//
//  Countdown.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/4/20.
//

import Foundation

protocol CountdownDelegate: AnyObject {
    func countdownDidUpdate(timeRemaining: TimeInterval)
    func countdownDidFinish()
}

enum CountdownState {
    case started
    case finished
    case reset
}

class CountDown {
    
}
