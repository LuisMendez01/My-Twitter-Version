//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Luis Mendez on 2018-08-11.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var Tweets: [Tweet] = []//get tweets
    
    var refreshControl: UIRefreshControl!//! means better not be null or else crashes
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In TimelineViewController")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //make UITableViewCell separators go edge to edge
        //line will be farther away from edge of the left than of the right
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        //also include one more code of line in cellForRowAt, commented with a hashtag
        
        //tableView.rowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        // add refreshControl to tableView
        tableView.insertSubview(refreshControl, at: 0)//0 means it will show on the top
        
        //fetch data
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(){
    
        APIManager.shared.getHomeTimeLine(){ Tweets, error in
            
            self.Tweets = Tweets!
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            self.refreshControl.endRefreshing()
            print("In TimelineViewController:\(Tweet.count)")
        }
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        //remove cookie that stored the 20 tweeters first downloaded
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "hometimeline_tweets")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchData()//get now playing movies from the APIs
        }
    }
    
    /***********************
     * TableView functions *
     ***********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("In TimelineVC - Tweets.count = \(Tweets.count)")
        return Tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetViewCell
        
        //# goes with two lines of code in the viewDidLoad
        cell.layoutMargins = UIEdgeInsets.zero
        
        // No color when the user selects cell
        //cell.selectionStyle = .none
        
        // Use a Dark blue color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.6013489962, green: 0.6768889427, blue: 0.7566809058, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        
        //this code changes color of all cells
        cell.contentView.backgroundColor = #colorLiteral(red: 0.8153101802, green: 0.8805506825, blue: 0.8921775818, alpha: 0.92)
        
        cell.Tweet = Tweets[indexPath.row]
        
        return cell
    }

    @IBAction func logOutAction(_ sender: Any) {
         APIManager.logOut()
    }
}
