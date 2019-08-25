//
//  Event.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

enum Event<T> {
    case value(T)
    case error(Error)
}

extension Event {

    var value: T? {
        switch self {
        case .value(let value): return value
        case .error: return nil
        }
    }

    var error: Error? {
        switch self {
        case .value: return nil
        case .error(let error): return error
        }
    }

    func map<U>(_ transform: (T) -> U) -> Event<U> {
        switch self {
        case .value(let value): return .value(transform(value))
        case .error(let error): return .error(error)
        }
    }
}
