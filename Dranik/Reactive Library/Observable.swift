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

    private var subscriptions: [UUID: Subscription<T>] = [:]

    var strongReferences: [Any] = []

    static func pipe() -> (Sink<T>, Observable<T>) {
        let observable = Observable<T>()
        let sink = Sink<T> { [weak observable] in observable?.send($0) }
        return (sink, observable)
    }

    private func send(_ value: Event<T>) {
        for subscription in subscriptions.values {
            subscription(value)
        }
    }

    func subscribe(subscription: @escaping Subscription<T>) -> Disposable {
        let uuid = UUID()
        subscriptions[uuid] = subscription
        return Disposable {
            self.subscriptions[uuid] = nil
        }
    }

    func map<U>(_ transform: @escaping (T) -> U) -> Observable<U> {
        let (sink, observable) = Observable<U>.pipe()
        let disposable = subscribe { event in
            sink.emit(event: event.map(transform))
        }
        observable.strongReferences.append(disposable)
        return observable
    }

    func filter(_ predicate: @escaping (T) -> Bool) -> Observable<T> {
        let (sink, observable) = Observable<T>.pipe()
        let disposable = subscribe { event in
            switch event {
            case .value(let value):
                if predicate(value) { sink.emitValue(value) }
            case .error(let error):
                sink.emitError(error)
            }
        }
        observable.strongReferences.append(disposable)
        return observable
    }

    deinit {
        print("--- OBSERVABLE DEINITED ---")
    }
}

