//
//  UserHomeTableViewCell.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 26.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit

class UserHomeTableViewCell: UITableViewCell {

   
    @IBOutlet weak var userTweet: UILabel!
    
    var tweet : Tweet!{
        didSet{
            userTweet.text = tweet.text!
        }
    }
}
