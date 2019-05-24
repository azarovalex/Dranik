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
    var targetStrongReference: NSObject?

    private let bag = DisposeBag()

    static func pipe() -> (Sink<T>, Observable<T>) {
        let observable = Observable<T>()
        let sink = Sink<T> { [weak observable] in observable?.send($0) }
        return (sink, observable)
    }

    static func merge(observables: Observable<T>...) -> Observable<T> {
        let (sink, mergedObservables) = Observable<T>.pipe()
        for observable in observables {
            observable.subscribe { event in sink.emit(event: event) }
                .disposed(by: mergedObservables.bag)
        }
        return mergedObservables
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
        subscribe { event in
            sink.emit(event: event.map(transform))
        }.disposed(by: observable.bag)
        return observable
    }

    func filter(_ predicate: @escaping (T) -> Bool) -> Observable<T> {
        let (sink, observable) = Observable<T>.pipe()
        subscribe { event in
            switch event {
            case .value(let value):
                if predicate(value) { sink.emitValue(value) }
            case .error(let error):
                sink.emitError(error)
            }
        }.disposed(by: observable.bag)
        return observable
    }

    func flatMap<U>(_ transform: @escaping (T) -> Observable<U>) -> Observable<U> {
        let (sink, observable) = Observable<U>.pipe()
        subscribe { event in
            switch event {
            case .value(let value):
                transform(value)
                    .subscribe { event in sink.emit(event: event) }
                    .disposed(by: observable.bag)
            case .error(let error):
                sink.emitError(error)
            }
        }.disposed(by: observable.bag)
        return observable
    }


    deinit {
        print("--- OBSERVABLE DEINITED ---")
    }
}

