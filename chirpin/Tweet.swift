//
//  Tweet.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/25/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoriteCount: Int?
    var isRetweet: Bool?
    
    var originalUser: User?
    var originalText: String?
    var originalCreatedAtString: String?
    var originalCreatedAt: NSDate?
    
    var retweeted: Bool?
    var favorited: Bool?
    
    var id: Int?
    
//    var replyId: Int?
//    var replyText: String?
//    var replyScreenname: String?
    
    var retweetText: String?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!) // maybe make this lazy, b/c formatting is expensive
        
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        
        var retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        isRetweet = retweetedStatus != nil
        if isRetweet! {
            originalUser = User(dictionary: dictionary.valueForKeyPath("retweeted_status.user") as! NSDictionary)
            originalText = dictionary.valueForKeyPath("retweeted_status.text") as? String
            originalCreatedAtString = dictionary.valueForKeyPath("retweeted_status.created_at") as? String
            originalCreatedAt = formatter.dateFromString(originalCreatedAtString!)
        }
        
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        id = dictionary["id"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in array {
            var tweet = Tweet(dictionary: dictionary)
            // println(tweet.user?.profileImageUrl)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
