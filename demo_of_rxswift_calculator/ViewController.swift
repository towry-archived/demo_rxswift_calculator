//
//  ViewController.swift
//  demo_of_rxswift_calculator
//
//  Created by towry on 2017/6/22.
//  Copyright © 2017年 towry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    var disposeBag = DisposeBag()

    // Number buttons.
    @IBOutlet weak var btnZero: UIButton!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnDot: UIButton!  // "."

    // Operation buttons.
    @IBOutlet weak var btnEqual: UIButton! // =
    @IBOutlet weak var btnPlus: UIButton!  // +
    @IBOutlet weak var btnMinus: UIButton!  // -
    @IBOutlet weak var btnMultiply: UIButton!  // *
    @IBOutlet weak var btnDivide: UIButton!  // "/"
    @IBOutlet weak var btnPercent: UIButton!  // %
    @IBOutlet weak var btnChangeSign: UIButton!  // +/-
    @IBOutlet weak var btnClear: UIButton!  // C

    // Other
    @IBOutlet weak var display: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let actions: Observable<CalculatorAction> = Observable.merge([
            btnZero.rx.tap.map { _ in .append("0") },
            btnOne.rx.tap.map { _ in .append("1") },
            btnTwo.rx.tap.map { _ in .append("2") },
            btnThree.rx.tap.map { _ in .append("3") },
            btnFour.rx.tap.map { _ in .append("4") },
            btnFive.rx.tap.map { _ in .append("5") },
            btnSix.rx.tap.map { _ in .append("6") },
            btnSeven.rx.tap.map { _ in .append("7") },
            btnEight.rx.tap.map { _ in .append("8") },
            btnNine.rx.tap.map { _ in .append("9") },

            btnEqual.rx.tap.map { _ in .equal },
            btnPlus.rx.tap.map { _ in .operation(.addition) },
            btnMinus.rx.tap.map { _ in .operation(.subtraction) },
            btnMultiply.rx.tap.map { _ in .operation(.multiplication) },
            btnDivide.rx.tap.map { _ in .operation(.division) },
            btnPercent.rx.tap.map { _ in .percent },
            btnChangeSign.rx.tap.map { _ in .changeSign },
            btnClear.rx.tap.map { _ in .clear }
        ])

        let output: Observable<CalculatorState> = actions.scan(CalculatorState.initialState, accumulator: CalculatorState.reduce)
            .startWith(CalculatorState.initialState);
        
        output.map({ $0.screen })
            .bind(to: display.rx.text)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

