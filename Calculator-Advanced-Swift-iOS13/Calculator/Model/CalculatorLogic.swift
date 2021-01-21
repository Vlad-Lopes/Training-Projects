//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Vlad Lopes on 21/05/20.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    
    private var number: Double?
    
    private var intermediateCalculation: (firstNumber: Double, method: String)?
    
    mutating func setNumber (_ n: Double) {
        self.number = n
    }

    mutating func calculate(symbol: String) -> Double? {
    
        if let n = number {
            switch symbol {
            case "AC":
                return 0
            case "+/-":
                return n * -1
            case "%":
                return n / 100
            case "=":
                return performTwoNumCalculation(n2: n)
            default:
                intermediateCalculation = (firstNumber: n, method: symbol)
            }
        }
        return nil
    }
    
    private func performTwoNumCalculation(n2: Double) -> Double? {
        
        if let n1 = intermediateCalculation?.firstNumber,
           let calculation = intermediateCalculation?.method {
            switch calculation {
            case "+":
                return n1 + n2
            case "-":
                return n1 - n2
            case "×":
                return n1 * n2
            case "÷":
                return n1 / n2
            default:
                fatalError("The operation passed dont match any of the cases")
            }
        }
        return nil
    }
}
