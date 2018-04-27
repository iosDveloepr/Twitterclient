//
//  TweetsNavigationController.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 25.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsNavigationController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweet = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweet = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // Add refreshControl to tableView
        tableView.insertSubview(refreshControl, at: 0)
    
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCellHome", for: indexPath) as! TweetViewCell
        
        cell.tweet = tweet[indexPath.row]
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refreshControlAction (refreshControl: UIRefreshControl) {
        
        // Re-request hometimeline data
        TwitterClient.sharedInstance?.homeTimeline(success: { (moreTweets: [Tweet]) in
            for newTweet in moreTweets {
                self.tweet.insert(newTweet, at: 0)
                self.tableView.reloadData()
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
            
        })
        self.tableView.reloadData()
        
        // Tell refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
        self.performSegue(withIdentifier: "tweetsToLoginVCSegue", sender: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
