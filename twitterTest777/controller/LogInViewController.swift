//
//  ViewController.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 24.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController{
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      }

    @IBAction func loginBtn(_ sender: UIButton) {
        
        TwitterClient.sharedInstance?.login(success: {
            print ("You've Successfully logged in!")
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })
    }
    


} // class

