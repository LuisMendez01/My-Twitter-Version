//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Luis Mendez on 10/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: Int? // For favoriting, retweeting & replying
    var text: String? // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int? // Update favorite count label
    var retweeted: Bool? // Configure retweet button
    var user: User? // Author of the Tweet
    var createdAtString: String? // String representation of date posted
    
    // For Retweets
    var retweetedByUser: User?  // user who retweeted if tweet is retweet

    init(dictionary: [String : Any]){
        //super.init()
        var dictionary = dictionary
        
        // Is this a re-tweet?
        if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.retweetedByUser = User(dictionary: userDictionary)
            
            // Change tweet to original tweet
            dictionary = originalTweet
        }
        
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        
        // TODO: initialize user
        
        // TODO: Format and set createdAtString
        // Format createdAt date string
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String and set the createdAtString property
        createdAtString = formatter.string(from: date)
    }
    
    //returns Tweets when initialized with an array of Tweet Dictionaries
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        var tweets: [Tweet] = []
        for tweetDictionary in array {
            let tweet = Tweet(dictionary: tweetDictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    //Does same as above function
//    static func tweets(with array: [[String: Any]]) -> [Tweet] {
//        return array.flatMap({ (dictionary) -> Tweet in
//            Tweet(dictionary: dictionary)
//        })
//    }
}
