//
//  Tweet.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 26.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var rtCount: Int = 0
    var rtCountStr: String = ""
    var favCount: Int = 0
    var favCountStr: String = ""
    
    var retweeted: Bool?
    var retweetedStatus: Tweet?
    var faved: Bool?
    var timestamp: Date?
    var timeAgo: String?
    var id_str: String?
    
    var detailTimeStamp: String?
    var rtStatus: NSDictionary?
    
    
    init (dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweeted = (dictionary["retweeted"] as? Bool) ?? true
        faved = (dictionary["favorited"] as? Bool) ?? false
        favCount = (dictionary["favorite_count"] as? Int) ?? 0
        id_str = dictionary["id_str"] as? String
        //retweeted_status = (dictionary["retweeted_status"] as? Tweet) ?? false
        
        // tweet poster
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        rtStatus = dictionary["retweeted_status"] as? NSDictionary
        if let rtStatus = rtStatus {
            rtCount = rtStatus["retweet_count"] as? Int ?? 0
            favCount = (rtStatus["favourites_count"] as? Int) ?? 0
        } else {
            rtCount = (dictionary["retweet_count"] as? Int) ?? 0
        }
        
        
        
        rtCountStr = (rtCount > 0) ? "\(rtCount)" : ""
        favCountStr = (favCount > 0) ? "\(favCount)" : ""
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            detailTimeStamp = formatter.string(from: timestamp!)
            timeAgo = detailTimeStamp
        }
        
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        return tweets
    }
}
