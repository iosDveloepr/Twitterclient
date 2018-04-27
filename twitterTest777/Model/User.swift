//
//  User.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 25.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var headerURL: URL?
    var tagline: String?
    var following = true
    
    var headerURLString: String?
    var followers_count: Int?
    var following_count: Int?
    var tweetCount: Int?
    
    var userIDstr: String?
    var dictionary: NSDictionary?
    
    
    // De-serialization: stripping dictionary and selectively populating individual properties.
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        followers_count = dictionary["followers_count"] as? Int
        following_count = dictionary["friends_count"] as? Int
        
        
        headerURLString = dictionary["profile_banner_url"] as? String
        if headerURLString != nil {
            headerURLString?.append("/600x200")
        } else {
            headerURLString = dictionary["profile_background_image_url_https"] as? String
        }
        if let headerURLString = headerURLString {
            headerURL = URL(string: headerURLString)
        }
        
        tweetCount = dictionary["statuses_count"] as? Int
        userIDstr = dictionary["id_str"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
    }
    
    
    //TODO: use encode and decode with JSON object instead
    required init(coder tweetDecoder: NSCoder) {
        self.name = tweetDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.screenname = tweetDecoder.decodeObject(forKey: "screenname") as? String ?? ""
        self.tagline = tweetDecoder.decodeObject(forKey: "tagline") as? String ?? ""
        self.profileUrl = tweetDecoder.decodeObject(forKey: "profileUrl") as? URL
        self.followers_count = tweetDecoder.decodeObject(forKey: "followers_count") as? Int
        self.following_count = tweetDecoder.decodeObject(forKey: "following_count") as? Int
        self.headerURL = tweetDecoder.decodeObject(forKey: "headerURL") as? URL
        self.headerURLString = tweetDecoder.decodeObject(forKey: "headerURLString") as? String
        self.tweetCount = tweetDecoder.decodeObject(forKey: "tweetCount") as? Int
    }
    
    func encode (with tweetCoder: NSCoder) {
        tweetCoder.encode(name, forKey: "name")
        tweetCoder.encode(screenname, forKey: "screenname")
        tweetCoder.encode(tagline, forKey: "tagline")
        tweetCoder.encode(profileUrl, forKey: "profileUrl")
        tweetCoder.encode(followers_count, forKey: "followers_count")
        tweetCoder.encode(following_count, forKey: "following_count")
        tweetCoder.encode(headerURL, forKey: "headerURL")
        tweetCoder.encode(headerURLString, forKey: "headerURLString")
        tweetCoder.encode(tweetCount, forKey: "tweetCount")
    }
}
