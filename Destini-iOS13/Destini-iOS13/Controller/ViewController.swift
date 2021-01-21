//
//  ViewController.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    
    var storyBrain = StoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyBrain.nextStory(userChoice: "")
        updateUI()
    }

    @IBAction func choiceMade(_ sender: UIButton) {
        if sender.titleLabel?.text != "" {
            storyBrain.nextStory(userChoice: sender.titleLabel!.text!)
            
            updateUI()
            }
    }
    
    func updateUI() {
        let option = storyBrain.storyNumber
        
      storyLabel.text = storyBrain.stories[option].title
      choice1Button.setTitle(storyBrain.stories[option].choice1, for: .normal)
      choice2Button.setTitle(storyBrain.stories[option].choice2, for: .normal)
      }
    
}

