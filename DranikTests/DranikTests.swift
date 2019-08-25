//
//  DranikTests.swift
//  DranikTests
//
//  Created by Alex Azarov on 5/27/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import XCTest

@testable import Dranik_Demo

class DranikTests: XCTestCase {

    private var bag = DisposeBag()

    override func setUp() {
        super.setUp()
        bag = DisposeBag()
    }

    func testObservableMapping() {
        let tests = [
            mappingTester(input: [1, 2, 3, 4, 5], desiredOutput: [2, 3, 4, 5, 6], transform: { $0 + 1 }),
            mappingTester(input: ["", "a", "ab", "abcdef"], desiredOutput: [0, 1, 2, 6], transform: { $0.count }),
            mappingTester(input: ["", "a", "ab", "abcdef"], desiredOutput: ["", "a", "ab", "abcdef"], transform: { $0 })
        ]

        tests.forEach { XCTAssertTrue($0) }
    }

    func testObservableFiltering() {
        let tests = [
            filteringTester(input: [-5, 3, 8, 3, -8, -0], desiredOutput: [3, 8, 3, 0], predicate: { $0 >= 0}),
            filteringTester(input: [1, 2, 3, 4, 5, 6, 7], desiredOutput: [2, 4, 6], predicate: { $0 % 2 == 0})
        ]

        tests.forEach { XCTAssertTrue($0) }
    }

    func testObservableMerging() {
        let (sink1, observable1) = Observable<Int>.pipe()
        let (sink2, observable2) = Observable<Int>.pipe()

        let mergedObservable = Observable.merge(observables: observable1, observable2)
        var actualOutput = [Int]()

        mergedObservable.subscribe { event in
            guard let value = event.value else { return }
            actualOutput.append(value)
        }.disposed(by: bag)

        sink1.emitValue(0)
        sink2.emitValue(1)
        sink2.emitValue(2)
        sink1.emitValue(3)
        sink1.emitValue(4)
        sink1.emitValue(5)
        sink2.emitValue(6)
        sink2.emitValue(7)
        sink1.emitValue(8)

        XCTAssertEqual(actualOutput, Array(0...8))
    }

    func testFlatMap() {
        let (sink1, observable1) = Observable<Int>.pipe()
        let promise = expectation(description: "observable2 emitted value")
        var actualOutput = [Int]()

        observable1.flatMap { event -> Observable<Int> in
            let (sink2, observable2) = Observable<Int>.pipe()
            DispatchQueue.main.async {
                sink2.emitValue(2)
                sink2.emitValue(3)
                promise.fulfill()
            }
            return observable2
        }.subscribe { event in
            guard  let value = event.value else { return }
            actualOutput.append(value)
        }.disposed(by: bag)

        sink1.emitValue(1)

        wait(for: [promise], timeout: 5)
        XCTAssertEqual(actualOutput, [2, 3])
    }
}

private extension DranikTests {

    private func filteringTester<T: Equatable>(input: [T], desiredOutput: [T],
                                               predicate: @escaping (T) -> Bool) -> Bool {
        let (sink, observable) = Observable<T>.pipe()
        var actualOutput = [T]()

        observable
            .filter(predicate)
            .subscribe { event in
                guard let value = event.value else { return }
                actualOutput.append(value)
            }.disposed(by: bag)

        for value in input {
            sink.emitValue(value)
        }
        return actualOutput == desiredOutput
    }

    private func mappingTester<T, U: Equatable>(input: [T], desiredOutput: [U],
                                                transform: @escaping (T) -> U) -> Bool {
        let (sink, observable) = Observable<T>.pipe()
        var actualOutput = [U]()

        observable
            .map(transform)
            .subscribe { event in
                guard let value = event.value else { return }
                actualOutput.append(value)
            }.disposed(by: bag)

        for value in input {
            sink.emitValue(value)
        }
        return actualOutput == desiredOutput
    }
}
