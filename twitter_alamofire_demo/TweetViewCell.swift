//
//  TweetViewCell.swift
//  twitter_alamofire_demo
//
//  Created by Luis Mendez on 10/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
