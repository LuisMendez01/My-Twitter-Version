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
        backgroundView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        
        //this code changes color of all cells
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
        
        cell.tweetLabel.text = Tweets[indexPath.row].text
        
        return cell
    }

    @IBAction func logOutAction(_ sender: Any) {
         APIManager.logOut()
    }
}
