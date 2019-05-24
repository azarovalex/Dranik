//
//  Event.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

enum Event<T> {
    case value(value: T)
    case error(error: Error)
}
