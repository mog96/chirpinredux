//
//  RetweetViewController.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/27/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

class RetweetViewController: UIViewController {

    var selectedTweet: Tweet!
    
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retweetedByLabel.text = "\(selectedTweet.user!.name!) retweeted"
            
        self.profileImageView.setImageWithURL(NSURL(string: selectedTweet.originalUser!.profileImageUrl!)!)
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        
        self.nameLabel.text = selectedTweet.originalUser!.name
        self.screennameLabel.text = "@" + selectedTweet.originalUser!.screenname!
        self.dateLabel.text = selectedTweet.originalCreatedAt!.description
        self.tweetLabel.text = selectedTweet.originalText
        self.retweetCountLabel.text = "\(selectedTweet.retweetCount!)"
        self.favoriteCountLabel.text = "\(selectedTweet.favoriteCount!)"
        
        if selectedTweet.retweeted! {
            retweetButton.setBackgroundImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
        
        if selectedTweet.favorited! {
            favoriteButton.setBackgroundImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(sender: AnyObject) {
        // shit
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
