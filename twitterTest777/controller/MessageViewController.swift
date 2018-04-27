//
//  MessageViewController.swift
//  twitterTest777
//
//  Created by Anton Yermakov on 27.04.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var messageTextField: UITextView!
    
    @IBOutlet weak var clearTextViewButton: UIButton!
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    let maxTweetCount = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTextField.delegate = self
        self.messageTextField.becomeFirstResponder()
        
        self.clearTextViewButton.isHidden = true
        
    
    }
    
    func textViewDidChange(_ tweetTextView: UITextView) {
        self.countDown()
        if (Int(self.countDownLabel.text!)! < maxTweetCount) {
            self.clearTextViewButton.isHidden = false
        } else {
            self.clearTextViewButton.isHidden = true
        }
    }
    
    func countDown() {
        if (Int(self.countDownLabel.text!)! >= 1) {
            self.countDownLabel.text = "\(maxTweetCount - self.messageTextField.text.count)"
            self.countDownLabel.textColor = UIColor.lightGray
            
        } else {
            self.countDownLabel.text = "\(maxTweetCount - self.messageTextField.text.count)"
            if (Int(self.countDownLabel.text!)! >= 0) {
                self.countDownLabel.textColor = UIColor.lightGray
            } else {
                self.countDownLabel.textColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    
    
    @IBAction func clearTextView(_ sender: UIButton) {
        self.messageTextField.text = ""
        self.countDownLabel.text = "\(maxTweetCount)"
        self.countDownLabel.textColor = UIColor.lightGray
        self.clearTextViewButton.isHidden = true
    }
    
    @IBAction func makeATweet(_ sender: UIButton) {
        
        TwitterClient.sharedInstance?.POST(tweetText: messageTextField.text, success: { [weak self] in
            print("Tweet posted to timeline!")
            self?.messageTextField.text = ""
            self?.countDownLabel.text = "\(String(describing: self!.maxTweetCount))"
            self?.countDownLabel.textColor = UIColor.lightGray
            self?.clearTextViewButton.isHidden = true
            
        }) { (error) in
            print (error)
            print ("unable to post tweet!")
        }
    }
    

    

 

}  // class
