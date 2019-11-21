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
    
    public var passingTwitterName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient.withCurrentUser()
        self.dataSource = TWTRUserTimelineDataSource(screenName: passingTwitterName, apiClient: client)
        

        self.title = "@ShunzheMa"
        self.showTweetActions = false
    }
    
}
