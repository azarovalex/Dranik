//
//  DisposeBag.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import Foundation

final class DisposeBag {

    private var disposables = [Disposable]()

    func insert(disposable: Disposable) {
        disposables.append(disposable)
    }

    deinit {
        print("--- DISPOSEBAG DEINITED ---")
    }
}
