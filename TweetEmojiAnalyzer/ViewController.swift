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
    
    var timelineVC: TimelineViewer!
    
    var tweetTexts = [String]()
    
    /*
     Save data for all analysis.
     Display a table view.
     */
    @IBOutlet weak var analyzeResultTableView: UITableView!
    var analysis = [analysisResult]()
    
    /*
     Save the overall emoji use counter
     */
    @IBOutlet weak var overallResultTableView: UITableView!
    var globalEmojiCounter = [Character:Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up tableView delegation
        analyzeResultTableView.dataSource = self
        analyzeResultTableView.delegate = self
        overallResultTableView.dataSource = self
        overallResultTableView.delegate = self
    }

    @IBAction func actionPrepare(){
        timelineVC = TimelineViewer()
        timelineVC.passingTwitterName = twitterAccountField.text
        let navC = UINavigationController(rootViewController: timelineVC)
        self.present(navC, animated: true, completion: nil)
    }
    
    @IBAction func actionAnalyze(){
        
        //Make sure the tweets are loaded
        guard timelineVC != nil && timelineVC!.passingTwitterName != nil && twitterAccountField.text != "" && timelineVC!.passingTwitterName! == twitterAccountField.text else {
            return
        }
        
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
                //Add to global counter
                globalEmojiCounter(emoji: emoji)
            }
        }
        //Add to results table
        let resultEntry = analysisResult(twitterAccountName: twitterAccountField.text, topEmojis: Array(emojiCounter.keys.sorted()))
        analysis.append(resultEntry)
        self.analyzeResultTableView.reloadData()
        self.overallResultTableView.reloadData()
    }

}

/*
 Data source for UITableView
 */
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == analyzeResultTableView) {
            return analysis.count
        } else if (tableView == overallResultTableView) {
            return globalEmojiCounter.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowI = indexPath.row
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if (tableView == analyzeResultTableView) {
            
            //Fetch object
            let obj = analysis[rowI]
            //Prepare view
            cell.textLabel?.text = obj.twitterAccountName
            //Generate top 3
            var topEmojiStr = "Top Emojis: "
            for emojiChar in obj.topEmojis {
                topEmojiStr.append(String(emojiChar) + " ")
            }
            cell.detailTextLabel?.text = topEmojiStr
            
        } else if (tableView == overallResultTableView) {
            
            let sorted = globalEmojiCounter.sorted(by: { $0.value > $1.value })
            let emojiEntry = sorted[rowI]
            cell.textLabel?.text = "No. " + String(rowI + 1) + ". " + String(emojiEntry.key)
            cell.detailTextLabel?.text = "Used for " + String(emojiEntry.value) + " times"
            
            //Special background color for top 3
            if (rowI == 0) {
                cell.textLabel?.textColor = .black
                cell.backgroundColor = .systemRed
            } else if (rowI == 1) {
                cell.textLabel?.textColor = .black
                cell.backgroundColor = .systemOrange
            } else if (rowI == 2) {
                cell.textLabel?.textColor = .black
                cell.backgroundColor = .systemYellow
            }
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func globalEmojiCounter(emoji: Character) {
        if globalEmojiCounter.keys.contains(emoji) {
            globalEmojiCounter[emoji]! += 1
        } else {
            globalEmojiCounter[emoji] = 1
        }
    }
    
}
