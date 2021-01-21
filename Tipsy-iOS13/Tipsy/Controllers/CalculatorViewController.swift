//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    
    var tipValue = 0.1
    var splitValue = 2.0
    var billValue = 0.0
    var personAmount = 0.0
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        switch sender {
        case zeroPctButton:
            zeroPctButton.isSelected = true
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
            tipValue = 0.0
        case tenPctButton:
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = true
            twentyPctButton.isSelected = false
            tipValue = 0.1
        case twentyPctButton:
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = true
            tipValue = 0.2
        default:
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
        }
        billTextField.endEditing(true)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        billTextField.endEditing(true)
        splitValue = sender.value
        self.splitNumberLabel.text = String(format: "%.0f", splitValue)
        
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        billValue = Double(billTextField.text ?? "0.0")!
        personAmount = (billValue * (1 + tipValue)) / splitValue
        
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.personValue = personAmount
            destinationVC.peopleNumber = Int(splitValue)
            destinationVC.tipPercentage = Int(tipValue * 100)
        }
    }
    
}

