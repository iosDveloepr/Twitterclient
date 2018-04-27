//
//  TwitterClient.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 24.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    //OAuth
    // 5DmTl9Fwe2iGnrGfzo2Q5z4dz
    // LFDHXWlQLXlWBZ2LhP0ExncjjBe2kmOPWSyZb7uDaV5ApEoPRo
    // twittertest://oauth
    
  
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "INYjKa51KnYI0Ougt58NDKoc5", consumerSecret: "mh1XObzCXSka3CPYa63t9PE7VKMGdRcRte7lgzBWhpyafRDttQ")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twittertest://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("Request Token received")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token!)!)")!
            self.open(_url: url)
            
        }) { (error:Error?) -> Void in
            print ("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "user")
        
        if UserDefaults.standard.data(forKey: "user") == nil {
            print ("Succesfully cleared user info")
        }
        deauthorize()
    }
    
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Access Token received!")
            
            self.currentAccount(success: { (user: User) in
          
                let encodeData = NSKeyedArchiver.archivedData(withRootObject: user)
                UserDefaults.standard.set(encodeData, forKey: "user")
                
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
            
        }) {(error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure!(error!)
        }
    }
    

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(_: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
 
    func open(_url: URL) {
       UIApplication.shared.open(_url, options: [:], completionHandler: {(success) in
                print("Open url: \(success)")
            })
        }
    
   
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
      
        let count = ["count" : 800]
        
        get("1.1/statuses/home_timeline.json", parameters: count, progress: nil, success: {(_: URLSessionDataTask, response:
            Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }

    
    func userTimeline(_ settings: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let params = "?screen_name=" + settings

        get("1.1/statuses/user_timeline.json"+params, parameters: nil, progress: nil, success: {(_: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)

        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    

    
    
    func POST(tweetText: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/update.json", parameters: ["status": tweetText], progress: nil, success: { (_: URLSessionDataTask, resp) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print(error.localizedDescription)
        })
    }
    

} // class 
