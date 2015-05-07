//
//  TwitterClient.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/25/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

let twitterConsumerKey = "wbnZFag7pwI1B7SCyzm30hsDc"  // in production, these are pulled from PD list
let twitterConsumerSecret = "4AngFxiY1mMy0TEtNl0hgjXWkqOUtms1s9lx27qJXr77QcKT3m"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
    
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        // HOME TIMELINE
        
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            // println("home timeline: \(response)")
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("ERROR GETTING HOME TIMELINE")
            completion(tweets: nil, error: error)
        })
    }
    
    func composeTweet(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("ERROR POSTING TWEET")
            completion(tweet: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fetch request token and redirect to auth page in browser
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken() // cleans up before we get going
        // for when you are signed out
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "chirpin://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("GOT REQUEST TOKEN")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            println("FAILED REQUEST T0KEN")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func retweet(tweetID: Int?, completion: (status: Tweet?, error: NSError?) -> ()) {
        var retweetUrlString = "1.1/statuses/retweet/\(tweetID!).json"
        println(retweetUrlString)
        self.POST(retweetUrlString, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            
            println("U DONE")
            
            completion(status: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("ERROR RETWEETING")
            completion(status: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("GOT ACCESS TOKEN")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // CURRENT USER
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                // println("user: \(response)")
                
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("ERROR GETTING USER")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
            println("FAILURE GETTING ACCESS TOKEN")
            self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
}