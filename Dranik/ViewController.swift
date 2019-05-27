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

        let observable = Observable<String>.create { sink in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                sink.emitValue("Hello")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                sink.emitValue("World")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                sink.emitValue("!!!!")
            })
        }

        observable.subscribe { [weak self] event in
            guard let value = event.value else { return }
            self?.label.text = value
        }.disposed(by: bag)
    }

    @IBAction func deinitViewController(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = UIViewController()
    }

    deinit {
        print("--- VIEW CONTROLLER DEINITED ---")
    }
}

