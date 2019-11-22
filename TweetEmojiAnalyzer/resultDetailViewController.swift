//
//  resultListViewController.swift
//  TweetEmojiAnalyzer
//
//  Created by Shunzhe Ma on 11/21/19.
//  Copyright © 2019 Shunzhe Ma. All rights reserved.
//

import Foundation
import UIKit

class resultDetailViewController: UITableViewController {
    
    //Caller will pass the list of values here
    public var tweetsToDisplay = [String]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let rowI = indexPath.row
        guard rowI < tweetsToDisplay.count else { return cell } //Make sure it's in range
        let tweetContent = tweetsToDisplay[rowI]
        cell.textLabel?.text = tweetContent
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}
