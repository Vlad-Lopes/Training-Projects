//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class PredictionViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    
    let tweetCount = 100
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "Nd602VyyQAGn6ccXR1XGQ4Flg", consumerSecret: "H8yIjogx9gonvxDBPdZLwlp4cEcjkCiLOSwi5WiXHgkrmLKNry")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
            
    }

    @IBAction func predictPressed(_ sender: Any) {
        textField.resignFirstResponder()
        fetchTweets()
    
    }
    
    func fetchTweets() {
        
        if let searchText = textField.text {
        
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
             
                var tweets = [TweetSentimentClassifierInput]()
             
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
             
                self.makePrediction(with: tweets)
             
            }) { (error) in
                print("Error when searching Twitter with API \(error)")
            }
        }
        
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                        
            var predictionScore = 0
            var posPred = 0
            var negPred = 0
                        
            for pred in predictions {
                if pred.label == "Pos"{
                    predictionScore += 1
                    posPred += 1
                } else if pred.label == "Neg" {
                    negPred += 1
                    predictionScore -= 1
                }
            }
            
            updateUI(with: predictionScore, pos: posPred, neg: negPred)
        
                        
            } catch {
                print("There was an error making the prediction \(error)")
            }
    }
    
    func updateUI(with predictScore: Int, pos: Int, neg: Int) {
        
        if predictScore > 20 {
            sentimentLabel.text = "😍"
        } else if predictScore > 10 {
           sentimentLabel.text = "😀"
        } else if predictScore > 0 {
            sentimentLabel.text = "🙂"
        } else if predictScore == 0 {
            sentimentLabel.text = "😐"
        } else if predictScore > -10 {
            sentimentLabel.text = "🙁"
        } else if predictScore > -20 {
            sentimentLabel.text = "😡"
        } else {
            sentimentLabel.text = "🤮"
        }
        
        finalLabel.text = "Final Score: \(predictScore)"
        positiveLabel.text = "Positive: \(pos)"
        negativeLabel.text = "Negative: \(neg)"
        neutralLabel.text = "Neutral: \(100-pos-neg)"
        
    }
    
}

extension PredictionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
