//
//  ComposeViewController.swift
//  chirpin
//
//  Created by Mateo Garcia on 4/27/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var replyId = 0
    var replyScreenname = ""

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL(NSURL(string: "http://pbs.twimg.com/profile_images/500680582515675138/wLuHYhOu_normal.jpeg")!)

        if (replyScreenname != "") {
            tweetField.text = "@" + replyScreenname + " "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func onTweet(sender: AnyObject) {
        var params = NSMutableDictionary()
        if (replyId > 0) {
            params.setValue(replyId, forKey: "in_reply_to_status_id")
        }
        params.setValue(tweetField.text, forKey: "status")
        TwitterClient.sharedInstance.composeTweet(params, completion: { (tweet, error) -> () in
            if error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                println(error)
            }
        })
    }

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
