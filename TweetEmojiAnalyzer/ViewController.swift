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
    
    /*
     Save a mapping between the tweetID and text content
     so resultListViewController can show tweets with a
     certain emoji
     */
    var tweetIDToContent = [String: String]()
    
    /*
     A mapping from a certain emoji
     to all the ID of all tweets
     containing that emoji
     */
    var emojiToTweetID = [Character:[String]]()
    
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
            let textLine = tweet.author.formattedScreenName + ": " + tweet.text
            tweetIDToContent[tweet.tweetID] = textLine
            logText.append(textLine + "\n\n")
            //Analyze
            let extractedEmojis = tweet.text.getEmojis()
            for emoji in extractedEmojis {
                //Add to counter and Map the emoji to tweet ID
                //We are adding to emojiCounter and emojiTweetsMapping
                //at the same time so the key should be identital.
                if (emojiCounter.keys.contains(emoji) &&
                    emojiToTweetID.keys.contains(emoji)) {
                    emojiCounter[emoji]! += 1
                    emojiToTweetID[emoji]!.append(tweet.tweetID)
                } else {
                    emojiCounter[emoji] = 1
                    emojiToTweetID[emoji] = [tweet.tweetID]
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
            
            cell.selectionStyle = .none
            
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
        
        return cell
    }
    
    /*
     Clicking the overallResultTableView cell will present all the tweets with that emoji
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard tableView == overallResultTableView else { return }
        
        let rowI = indexPath.row
        let sorted = globalEmojiCounter.sorted(by: { $0.value > $1.value })
        let emojiEntry = sorted[rowI]
        
        //Fetch the tweet IDs
        guard let tweetIDs = emojiToTweetID[emojiEntry.key] else { return }
        //Convert to tweets
        var tweetContents = [String]()
        for tweetID in tweetIDs {
            if let content = tweetIDToContent[tweetID] {
                if (!tweetContents.contains(content)) {
                    tweetContents.append(content)
                }
            }
        }
        
        //Pass to and present resultDetailViewController
        let detailVC = resultDetailViewController()
        detailVC.tweetsToDisplay = tweetContents
        
        DispatchQueue.main.async {
            self.present(detailVC, animated: true, completion: nil)
        }
        
    }
    
}

/*
 Small helper functions
 */
extension ViewController {
    
    /*
     Add a certain emoji to global counter
     */
    func globalEmojiCounter(emoji: Character) {
        if globalEmojiCounter.keys.contains(emoji) {
            globalEmojiCounter[emoji]! += 1
        } else {
            globalEmojiCounter[emoji] = 1
        }
    }
    
}
