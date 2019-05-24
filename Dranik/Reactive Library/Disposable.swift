//
//  Disposable.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

final class Disposable {

    private let disposeClosure: () -> Void

    init(disposeClosure: @escaping () -> Void) {
        self.disposeClosure = disposeClosure
    }

    func disposed(by bag: DisposeBag) {
        bag.insert(disposable: self)
    }

    deinit {
        disposeClosure()
        print("--- DISPOSABLE DEINITED ---")
    }
}
