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

    var observable: Observable<String>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.observable = textField.textObservable()
        observable?.subscribe { [weak self] event in
            guard case let .value(newValue) = event else { return }
            self?.label.text = newValue
        }
    }

    @IBAction func deinitViewController(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = UIViewController()
    }

    deinit {
        print("--- VIEW CONTROLLER DEINITED ---")
    }
}

