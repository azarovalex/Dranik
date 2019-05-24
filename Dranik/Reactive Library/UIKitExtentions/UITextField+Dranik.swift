//
//  UITextField+Dranik.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import UIKit

extension UITextField {

    func textObservable() -> Observable<String> {
        let (sink, observable) = Observable<String>.pipe()
        let target = ObservationTarget(object: self, keyPath: #keyPath(text)) { sink.emitValue($0) }
        addTarget(target, action: #selector(ObservationTarget<String>.handleChange), for: .editingChanged)
        observable.targetStrongReference = target
        return observable
    }
}
