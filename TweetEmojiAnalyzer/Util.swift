//
//  Util.swift
//  TweetEmojiAnalyzer
//
//  Created by Shunzhe Ma on 11/20/19.
//  Copyright © 2019 Shunzhe Ma. All rights reserved.
//

import Foundation

/*
 Used to analyze the result of one analysis session
 */
struct analysisResult {
    var twitterAccountName: String!
    var topEmojis: [Character]!
}

/*
 Used to extract emoji characters from String
 */
extension String {
    
    /*
     Numbers are also counted as properties.isEmoji
     so we need to return false for numbers
     */
    func isDigit(_ char: Character) -> Bool {
        let digits: [Character] = ["0", "1", "2", "3",
                                   "4", "5", "6", "7",
                                   "8", "9", "#", "@"]
        return digits.contains(char)
    }
    
    func getEmojis() -> [Character] {
        var result = [Character]()
        for singleChar in self.unicodeScalars {
            let char = Character(singleChar)
            if (singleChar.properties.isEmoji &&
                !isDigit(char)) {
                result.append(char)
            }
        }
        return result
    }
    
}
