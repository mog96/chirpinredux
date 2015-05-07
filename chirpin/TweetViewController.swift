//
//  TweetViewController.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/27/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

//@objc protocol TweetViewControllerDelegate {
//    optional func tweetViewController(tweetViewController: TweetViewController, dismissProgressHUD: Bool)
//}

class TweetViewController: UIViewController {
    
    // var delegate: TweetViewControllerDelegate?
    var selectedTweet: Tweet!

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
        
        self.profileImageView.setImageWithURL(NSURL(string: selectedTweet.user!.profileImageUrl!)!)
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        
        self.nameLabel.text = selectedTweet.user!.name
        self.screennameLabel.text = "@" + selectedTweet.user!.screenname!
        self.dateLabel.text = selectedTweet.createdAt!.description
        self.tweetLabel.text = selectedTweet.text
        self.retweetCountLabel.text = "\(selectedTweet.retweetCount!)"
        self.favoriteCountLabel.text = "\(selectedTweet.favoriteCount!)"
        
        if selectedTweet.retweeted! {
            retweetButton.setBackgroundImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
        
        if selectedTweet.favorited! {
            favoriteButton.setBackgroundImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        retweetButton.setBackgroundImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        favoriteButton.setBackgroundImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        println("LALALALALALALA")
//        delegate?.tweetViewController?(self, dismissProgressHUD: true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nc = segue.destinationViewController as! UINavigationController
        var vc = nc.viewControllers[0] as! ComposeViewController
        vc.replyId = selectedTweet.id!
        vc.replyScreenname = selectedTweet.user!.screenname!
    }
}
