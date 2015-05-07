//
//  HomeViewController.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/25/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate { // , TweetViewControllerDelegate {
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var replyId = 0
    var replyScreenname = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    // var dismissProgressHUD = false
    
//    override func viewWillAppear(animated: Bool) {
//        println("FART")
//        if !dismissProgressHUD {
//            SVProgressHUD.show()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        refreshData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black;
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tweet = self.tweets?[indexPath.row]
        if let tweet = tweet {
            if !tweet.isRetweet! {
                var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
                cell.setUpCell(tweet)
                cell.delegate = self
                return cell
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("RetweetCell") as! RetweetCell
                cell.setUpCell(tweet)
                cell.delegate = self
                return cell
            }
        } else {
            return tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numTweets = tweets?.count {
            return numTweets
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // performSegueWithIdentifier("tweetSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Refresh
    
    func refreshData() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            // SVProgressHUD.dismiss()
        })
    }
    
    func onRefresh() {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    // MARK: Actions
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    // MARK: Protocol implementations
    
    func composeReply(cell: TweetCell) {
        replyId = cell.tweet!.id!
        replyScreenname = cell.tweet!.user!.screenname!
        performSegueWithIdentifier("composeSegue", sender: nil)
    }
    
//    func tweetViewController(tweetViewController: TweetViewController, dismissProgressHUD: Bool) {
//        println("POOP")
//        self.dismissProgressHUD = dismissProgressHUD
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeSegue" {
            var nc = segue.destinationViewController as! UINavigationController
            var vc = nc.viewControllers[0] as! ComposeViewController
            vc.replyId = replyId
            vc.replyScreenname = replyScreenname
        } else {
            var cell = sender as! UITableViewCell
            var indexPath = tableView.indexPathForCell(cell)!
            if cell.reuseIdentifier == "TweetCell" {
                var vc = segue.destinationViewController as! TweetViewController
                vc.selectedTweet = self.tweets![indexPath.row]
            } else if cell.reuseIdentifier == "RetweetCell" {
                var vc = segue.destinationViewController as! RetweetViewController
                vc.selectedTweet = self.tweets![indexPath.row]
            }
        }
    }

}
