//
//  ViewController.swift
//  TweetEmojiAnalyzer
//
//  Created by Shunzhe Ma on 11/20/19.
//  Copyright © 2019 Shunzhe Ma. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {
    
    @IBOutlet weak var twitterAccountField: UITextField!
    @IBOutlet weak var twitterCategoryField: UITextField!
    @IBOutlet weak var numOfFetchField: UITextField!
    
    @IBOutlet weak var logTextView: UITextView!
    var logText: String = "" {
        willSet {
            DispatchQueue.main.async {
                self.logTextView.text = newValue
                let bottom = NSMakeRange(newValue.count - 1, 1)
                self.logTextView.scrollRangeToVisible(bottom)
            }
        }
    }
    
    let timelineVC = TimelineViewer()
    
    var tweetTexts = [String]()
    
    /*
     Save data for all analysis.
     Display a table view.
     */
    @IBOutlet weak var analyzeResultTableView: UITableView!
    var analysis = [analysisResult]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up tableView delegation
        analyzeResultTableView.dataSource = self
        analyzeResultTableView.delegate = self
    }

    @IBAction func actionPrepare(){
        let navC = UINavigationController(rootViewController: timelineVC)
        self.present(navC, animated: true, completion: nil)
    }
    
    @IBAction func actionAnalyze(){
        var emojiCounter = [Character:Int]()
        //Fetch data from timelineVC
        let counter = timelineVC.countOfTweets()
        logText.append("There are " + String(counter) + " loaded tweets.\n\n")
        for i in 0..<counter {
            //Read each individual tweets
            let tweet = timelineVC.tweet(at: Int(i))
            let textLine = tweet.tweetID + ": " + tweet.text
            tweetTexts.append(textLine)
            logText.append(textLine + "\n\n")
            //Analyze
            let extractedEmojis = tweet.text.getEmojis()
            for emoji in extractedEmojis {
                //Add to counter
                if (emojiCounter.keys.contains(emoji)) {
                    emojiCounter[emoji]! += 1
                } else {
                    emojiCounter[emoji] = 1
                }
            }
        }
        //Filter
        let sorted = emojiCounter.sorted(by: { $0.value > $1.value })
        //Update log
        logText.append("Result: " + emojiCounter.description)
        //Update chart
        
        //Add to results table
        let resultEntry = analysisResult(twitterAccountName: twitterAccountField.text, twitterAccountCategory: twitterCategoryField.text, topEmojis: Array(emojiCounter.keys.sorted()))
        analysis.append(resultEntry)
        self.analyzeResultTableView.reloadData()
    }

}

/*
 Data source for UITableView
 */
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analysis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Fetch object
        let rowI = indexPath.row
        let obj = analysis[rowI]
        //Prepare view
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = obj.twitterAccountName + "(" + obj.twitterAccountCategory + ")"
        //Generate top 3
        var topEmojiStr = "Top Emojis: "
        for emojiChar in obj.topEmojis {
            topEmojiStr.append(String(emojiChar) + " ")
        }
        cell.detailTextLabel?.text = topEmojiStr
        return cell
    }
    
}
