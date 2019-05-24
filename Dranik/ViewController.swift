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

    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let textObservable = textField.textObservable()
            .map { $0 + " LOL" }


        DispatchQueue.concurrentPerform(iterations: 10_0000) { _ in
            textObservable
                .subscribe { print($0) }
                .disposed(by: bag)
        }
    }

    @IBAction func deinitViewController(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = UIViewController()
    }

    deinit {
        print("--- VIEW CONTROLLER DEINITED ---")
    }
}

