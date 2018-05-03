//
//  CalculatorBrain.swift
//  CalculatorSwift
//
//  Created by Hongfei Zhai on 2018/5/3.
//  Copyright © 2018年 yuanding. All rights reserved.
//

import Foundation

func changeSign(operand:Double) -> Double {
    return -operand
}

func multiply(op1: Double,op2: Double) -> Double {
    return op1 * op2
}
//swift里边常用的class是结构体string，array。。。
//class有继承 在堆里，有指向类的指针访问
//struct 没有继承，内存不在堆里，靠复制传递

struct CalculatorBrain {
    //累计器
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
//        case unaryOperation
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    //eg#pragma hf =======(Double) -> Double=======
    /*
     func changeSign(operand:Double) -> Double {
        return -operand
     }
     var number: (Double) -> Double
     number = changeSign
     let result = number(10)   // result = -10
     
     */
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),//Double.pi
        "e" : Operation.constant(M_E),
//        "√" : Operation.unaryOperation,//sqrt
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({-$0}),
//        "x" : Operation.binaryOperation(multiply),
//        "x" : Operation.binaryOperation({(op1: Double,op2: Double) -> Double in
//            return op1 * op2
//            }),
        "x" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        //以下switch语法逻辑用一张运算符表来代替
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
//        switch symbol {
//        case "π":
//            //vc中写法
//            //                dispaly.text = String(Double.pi)//"\(Double.pi)"
////            displayValue = Double.pi
//            accumulator = Double.pi
//        case "√":
//            //                let operand = Double(dispaly.text!)!
//            //                dispaly.text = String(sqrt(operand))
////            displayValue = sqrt(displayValue)
//            if let operand = accumulator {
//                accumulator = sqrt(operand)
//            }
//        default:
//            break
//        }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation:PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand,secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {//这个方法可以改变结构体私有变量的值得mutating标记
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
