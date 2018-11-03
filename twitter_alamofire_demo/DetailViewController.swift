//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Luis Mendez on 11/2/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var Tweet: Tweet!//the tweet
    
    var comments: [String] = ["Comment1", "Comment2", "Comment3"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self//for didSelectRowAt func tableView to work
        
        //tableView.rowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
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
            
            
            cell.Tweet = Tweet
            
            return cell
                
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as UITableViewCell
            
            //this code changes color of all cells
            cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
            
            cell.textLabel?.text = comments[indexPath.row]            
            return cell
        }
        // return the default cell if none of above succeed
        //return UITableViewCell()
    }
}
