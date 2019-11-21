//
//  TimelineViewer.swift
//  TweetEmojiAnalyzer
//
//  Created by Shunzhe Ma on 11/20/19.
//  Copyright © 2019 Shunzhe Ma. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class TimelineViewer: TWTRTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient.withCurrentUser()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "ShunzheMa", apiClient: client)

        self.title = "@ShunzheMa"
        self.showTweetActions = false
    }

    func tweetView(tweetView: TWTRTweetView, didSelectTweet tweet: TWTRTweet) {
        print("Selected tweet with ID: \(tweet.tweetID)")
    }
    
}
