//
//  TweetViewCell.swift
//  twitter_alamofire_demo
//
//  Created by Luis Mendez on 10/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import ActiveLabel

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: ActiveLabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    
    var Tweet: Tweet! {
        didSet {
            authorNameLabel.text = Tweet.user?.name
            usernameLabel.text = ("@\(Tweet.user?.screenName ?? "ScreenName")")
            createdAtLabel.text = Tweet.createdAtString
            retweetCountLabel.text = "\(Tweet.retweetCount ?? -1)"
            favoriteCountLabel.text = "\(Tweet.favoriteCount ?? -1)"
            
            if Tweet.favorited! {
                likeBtn.setImage(UIImage(named: "heart2.png"), for: .normal)
            } else {
                likeBtn.setImage(UIImage(named: "heart.png"), for: .normal)
            }
            
            if Tweet.retweeted! {
                retweetBtn.setImage(UIImage(named: "retweet2.png"), for: .normal)
            } else {
                retweetBtn.setImage(UIImage(named: "retweet.png"), for: .normal)
            }

            profileImageView.af_setImage(
                withURL: Tweet.profileImageUrl!,
                completion: (nil)
            )
            
            tweetLabel.numberOfLines = 0
            tweetLabel.enabledTypes = [.mention, .hashtag, .url]
            
            
            tweetLabel.customize { label in
                label.text = Tweet.text
                label.textColor = .black
                label.hashtagColor = #colorLiteral(red: 0.2609414458, green: 0.2709193528, blue: 0.4761442542, alpha: 1)
                label.mentionColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
                label.URLColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                //label.handleMentionTap { self.alert("Mention", message: $0) }
                //label.handleHashtagTap { self.alert("Hashtag", message: $0) }
                //label.handleURLTap { self.alert("URL", message: $0.absoluteString) }
            }
            
            tweetLabel.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            
            tweetLabel.handleURLTap { url in UIApplication.shared.open(url, options: [:], completionHandler: nil)}
            /*
            label.handleCustomTap(for: customType) { element in
                print("Custom type tapped: \(element)")
            }*/
            
            tweetLabel.urlMaximumLength = 15
            //tweetLabel.text = label.text
 
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTapLike(_ sender: Any) {
        //1.Update the local model (tweet) properties to reflect it’s been favorited by updating the favorited bool and incrementing the favoriteCount
        
        if Tweet.favorited! {
            Tweet.favorited = false
            Tweet.favoriteCount! -= 1
            likeBtn.setImage(UIImage(named: "heart.png"), for: .normal)
            refreshData("https://api.twitter.com/1.1/favorites/destroy.json")
        } else {
            Tweet.favorited = true
            Tweet.favoriteCount! += 1
            likeBtn.setImage(UIImage(named: "heart2.png"), for: .normal)
            refreshData("https://api.twitter.com/1.1/favorites/create.json")
        }
    }
    
    func refreshData(_ url: String) {
        
        APIManager.shared.favoriteOrRetweet(Tweet, url) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.favoriteCountLabel.text = "\(self.Tweet.favoriteCount ?? -1)"
                self.retweetCountLabel.text = "\(self.Tweet.retweetCount ?? -1)"
                print("Successfully favorited/retweeted or unfavorited/unretweeted the following Tweet: \n\(tweet.text!)")
            }
        }//APIManager
    }
    
    //retweeting is easy see else, unretweeting is a bit complicated, gotta do it in steps
    // Step 1 happens in Tweet class along with User too
    // 1. Determine the id of the original tweet
    //  a. if retweeted tweet was an original tweet then you'll want to store its id_str
    //  b. if retweeted tweet was a retweet -> go under retweeted_status and extract its id
    // Step 2 happens here
    // 2. Get id of the logged-in user's retweet
    //  a. in order to get id of whomever is retweeting - > do a GET request with id found in step 1(original id) and include_my_retweet in the string
    //  b. id will be found in current_user_retweet
    //  c. finally do a POST just like with favorites/likes
    @IBAction func didTapRetweet(_ sender: Any) {
        
        if Tweet.retweeted! {
            Tweet.retweeted = false
            Tweet.retweetCount! -= 1
            retweetBtn.setImage(UIImage(named: "retweet.png"), for: .normal)
            
            //Wheather this tweet was retweeted before or not I took care of that in Tweet Class
            let original_tweet_id = String(Tweet.id!)
              
                
            // step 2
            // a.
            //Get the original tweet first then extract its id
            APIManager.shared.get_id_of_retweet("https://api.twitter.com/1.1/statuses/show/" + original_tweet_id + ".json?include_my_retweet=1"){ (tweet: Tweet?, error: Error?) in
                
                if let error = error {
                    print("Error getting original tweet: \(error.localizedDescription)")
                } else {
                    //get id of original tweet
                    let retweet_id = tweet?.id
                    
                    // step 3
                    //finally post the retweet
                    let urlString = "https://api.twitter.com/1.1/statuses/unretweet/\(retweet_id!).json"
                    self.refreshData(urlString)
                }
            }
            
        } else {
            Tweet.retweeted = true
            Tweet.retweetCount! += 1
            retweetBtn.setImage(UIImage(named: "retweet2.jpg"), for: .normal)
            
            let urlString = "https://api.twitter.com/1.1/statuses/retweet/\(Tweet.id!).json"
            refreshData(urlString)
        }
    }//didTapRetweet
}
