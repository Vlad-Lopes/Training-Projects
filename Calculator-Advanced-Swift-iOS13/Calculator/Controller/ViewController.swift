//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var isFinishedTypeNumber = true
    
    private var displayValue: Double {
        get {
          guard let number = Double(displayLabel.text!) else {
            fatalError("Error converting display label text into a Double")}
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    private var calculator = CalculatorLogic()
    
    @IBOutlet weak var displayLabel: UILabel!
    
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        //What should happen when a non-number button is pressed
        
        isFinishedTypeNumber = true
        
        calculator.setNumber(displayValue)
        
        if let calcMeth = sender.currentTitle {
            
   //         let calculator = CalculatorLogic(n: displayValue)
            if let result = calculator.calculate(symbol: calcMeth) {
                displayValue = result
            }
        }
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        //What should happen when a number is entered into the keypad
    
        if let newValue = sender.currentTitle {
            if isFinishedTypeNumber == true {
                displayLabel.text = newValue
                isFinishedTypeNumber = false
            } else {
                if newValue == "." {
                   
                    let isInt = floor(displayValue) == displayValue
                    if !isInt {
                        return
                    }
                }
                displayLabel.text = displayLabel.text! + newValue
            }
        }
    }

}

