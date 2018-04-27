//
//  UserHomeViewController.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 26.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var screenname: String?
 
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let decodeData = UserDefaults.standard.data(forKey: "user"),
            let currUser = NSKeyedUnarchiver.unarchiveObject(with: decodeData) as? User {
            self.screenname = currUser.screenname!
       
    
        }
        
        print(screenname)
        
    
        TwitterClient.sharedInstance?.userTimeline(self.screenname!, success: {(tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        
   
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return tweets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserHomeTableViewCell
        cell.tweet = tweets[indexPath.row]
       return cell
    }

}
