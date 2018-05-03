//
//  ViewController.swift
//  CalculatorSwift
//
//  Created by Hongfei Zhai on 2018/5/3.
//  Copyright © 2018年 yuanding. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // ! -> ? 隐式解析可选类型 可选初始化自动为nil
    @IBOutlet weak var dispaly: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    
    //_一般最多只用在第一个参数的标签
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = dispaly.text!
            dispaly.text = textCurrentlyInDisplay + digit
        } else {
            dispaly.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue : Double {
        get {
            return Double(dispaly.text!)!
        }
        set {
            dispaly.text = String(newValue)
        }
    }
    
    //Model
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            }
        if let result = brain.result {
            displayValue = result
        }
    
    }
    
    
    //eg
//    func drarwHorizontaLine(form startX: Double, to endX: Double, using color: UIColor) -> Void {}
    
}

