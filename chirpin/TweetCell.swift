//
//  TweetCell.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/26/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func composeReply(cell: TweetCell)
}

class TweetCell: UITableViewCell {
    
    var tweet: Tweet?
    var delegate: TweetCellDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions
    
    @IBAction func onReply(sender: AnyObject) {
        delegate?.composeReply(self)
    }

    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet?.id, completion: { (status, error) -> () in
            if (error == nil) {
                self.retweetButton.setBackgroundImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        self.favoriteButton.setBackgroundImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
    }
    
    // MARK: Setup
    
    func setUpCell(tweet: Tweet) {
        self.profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
        self.nameLabel.text = tweet.user!.name
        self.screennameLabel.text = "@" + tweet.user!.screenname!
        self.dateLabel.text = timeElapsed(tweet.createdAt!)
        self.tweetLabel.text = tweet.text
        
        if tweet.retweeted! {
            self.retweetButton.setBackgroundImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
        
        if tweet.favorited! {
            self.favoriteButton.setBackgroundImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
        
        self.tweet = tweet
    }
    
    // MARK: Date
    
    func timeElapsed(date: NSDate) -> String {
        if let hours = hoursFrom(date) {
            return "\(hours)h"
        } else if let minutes = minutesFrom(date) {
            return "\(minutes)m"
        } else {
            return "\(secondsFrom(date))s"
        }
    }
    
    func hoursFrom(date: NSDate) -> Int? {
        var hours = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: NSDate(), options: nil).hour
        if hours == 0 {
            return nil
        } else {
            return hours
        }
    }
    
    func minutesFrom(date: NSDate) -> Int? {
        var minutes = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: NSDate(), options: nil).minute
        if minutes == 0 {
            return nil
        } else {
            return minutes
        }
    }
    
    func secondsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: NSDate(), options: nil).second
    }
}
