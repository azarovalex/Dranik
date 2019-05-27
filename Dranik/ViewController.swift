//
//  ViewController.swift
//  Dranik
//
//  Created by Alex Azarov on 5/24/19.
//  Copyright © 2019 Azarov Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var originalObservableTextField: UITextField!
    @IBOutlet private var filterExampleLabel: UILabel!
    @IBOutlet private var mapExampleLabel: UILabel!
    @IBOutlet private var mergeObservableTextField: UITextField!
    @IBOutlet private var mergeExampleLabel: UILabel!
    @IBOutlet private var flatMapExampleLabel: UILabel!


    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let observable = originalObservableTextField.textObservable()

        observable
            .filter { $0.count % 2 == 0}
            .subscribe { [weak self] event in
                guard let value = event.value else { return }
                self?.filterExampleLabel.text = value
            }.disposed(by: bag)

        observable
            .map { $0.count + 5 }
            .subscribe { [weak self] event in
                guard let value = event.value else { return }
                self?.mapExampleLabel.text = String(value)
            }.disposed(by: bag)

        let secondObservable = mergeObservableTextField.textObservable()
        Observable.merge(observables: observable, secondObservable)
            .subscribe { [weak self] event in
                guard let value = event.value else { return }
                self?.mergeExampleLabel.text = value
            }.disposed(by: bag)

        observable
            .flatMap { value -> Observable<String> in
                let (sink, observable) = Observable<String>.pipe()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    sink.emitValue(value)
                })
                return observable
            }
            .subscribe { [weak self] event in
                guard let value = event.value else { return }
                self?.flatMapExampleLabel.text = value
            }.disposed(by: bag)
    }

    @IBAction func deinitViewController(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = UIViewController()
    }

    deinit {
        print("--- VIEW CONTROLLER DEINITED ---")
    }
}

