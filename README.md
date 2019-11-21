# TwitterEmojiAnalyzer

## What is it?
This iOS app helps fetch timeline tweets from a given Twitter username and analyzes the usage of emoji in all the loaded tweets. It's developed for a small course project demo and will not be maintained by me.

## Background
I'm taking a course about Language and Culture at CMU, and it requires a final project. I was thinking: maybe I can use my computer science skills on this one to make it more interesting. So I decided to analyze the usage of emojis by different categories of Twitter accounts. (What are the top emojis for entertainment accounts, news accounts, tech reviewers' accounts, etc.)

## The UI

The interface contains configurations (on the very top), logs (on top), and two table views (with the left one showing the analyzing results and the right one showing the overall emoji usage counting).

## How to use?
0. Provide a Twitter developer key and secret in `AppDelegate.Swift`, you can obtain one [here](https://developer.twitter.com/en.html)
1. On the top of the app, enter the Twitter username (like: AppleMusic)
2. Click on `Load Tweets`. You will see a list of tweets for that username, scroll to load the tweets you want to analuze (the more you scroll, the more tweets get loaded and analyzed. There might be a better way to fetch timeline).
3. Now close the timeline view by swipe down the title bar, and click on analysis.

![image](https://github.com/msztech/TwitterEmojiAnalyzer/blob/master/screenshot.jpeg?raw=true)

## Frameworks

(Pod files are included in the Github Repo for version consistency and convenience for you to compile)

This app uses the [TwitterKit](https://github.com/twitter-archive/twitter-kit-ios) framework. And it's using `TWTRTimelineViewController` to load the tweets of a specific user and using `- (TWTRTweet *)tweetAtIndex:(NSInteger)index;` to fetch the tweet at a specific index. That's why it's important to load the tweets in the timeline view controller first.

## License
MIT License

Copyright (c) [2019] [Shunzhe Ma]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
