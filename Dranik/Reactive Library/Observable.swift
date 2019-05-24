//
//  Observable.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

final class Observable<T> {

    typealias Subscription<T> = (Event<T>) -> Void

    private var subscriptions: [Subscription<T>] = []

    var strongReferences: [Any] = []

    static func pipe() -> (Sink<T>, Observable<T>) {
        let observable = Observable<T>()
        let sink = Sink<T> { [weak observable] in observable?.send($0) }
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

    deinit {
        print("--- OBSERVABLE DEINITED ---")
    }
}

