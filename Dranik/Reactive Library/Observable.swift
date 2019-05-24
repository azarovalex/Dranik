//
//  Observable.swift
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

typealias Subscription<T> = (Event<T>) -> Void


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
        eventHandler(.value(value: value))
    }

    func emitError(_ error: Error) {
        eventHandler(Event<T>.error(error: error))
    }
}

final class Observable<T> {
    private var subscriptions: [Subscription<T>] = []

    static func pipe() -> (Sink<T>, Observable<T>) {
        let observable = Observable<T>()
        let sink = Sink<T> { observable.send($0) }
        return (sink, observable)
    }

    private func send(_ value: Event<T>) {
        for subscription in subscriptions {
            subscription(value)
        }
    }

    func subscribe(subscription: @escaping Subscription<T>) {
        subscriptions.append(subscription)
    }
}

