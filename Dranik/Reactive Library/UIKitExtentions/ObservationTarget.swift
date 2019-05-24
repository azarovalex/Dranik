//
//  ObservationTarget.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

final class ObservationTarget<T>: NSObject {
    let keyPath: String
    let object: NSObject
    let closure: (T) -> Void

    init(object: NSObject, keyPath: String, closure: @escaping (T) -> Void) {
        self.keyPath = keyPath
        self.object = object
        self.closure = closure
    }

    @objc func handleChange() {
        closure(object.value(forKeyPath: keyPath) as! T)
    }

    deinit {
        print("--- TARGET DEINITED ---")
    }
}
