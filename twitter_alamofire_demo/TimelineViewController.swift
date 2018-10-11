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
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In TimelineViewController")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.rowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /***********************
     * TableView functions *
     ***********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetViewCell
        
        // No color when the user selects cell
        //cell.selectionStyle = .none
        
        // Use a Dark blue color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        
        //this code changes color of all cells
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
        
        cell.tweetLabel.text = "Que!"//"\(posts[indexPath.row])"
        
        return cell
    }

}
