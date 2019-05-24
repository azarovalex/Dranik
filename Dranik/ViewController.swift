//
//  ViewController.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var textField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        let (sink, observable) = Observable<String>.pipe()
        observable.subscribe { event in
            print(event)
        }
        sink.emitValue("Hello")
    }
}

