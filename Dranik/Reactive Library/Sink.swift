//
//  Sink.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

final class Sink<T> {

    typealias EventHandler = (Event<T>) -> Void

    private let eventHandler: EventHandler

    init(eventHandler: @escaping EventHandler) {
        self.eventHandler = eventHandler
    }

    func emit(event: Event<T>) {
        eventHandler(event)
    }

    func emitValue(_ value: T) {
        eventHandler(.value(value))
    }

    func emitError(_ error: Error) {
        eventHandler(.error(error))
    }

    deinit {
        print("--- SINK DEINITED ---")
    }
}
