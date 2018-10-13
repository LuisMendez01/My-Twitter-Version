//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Luis Mendez on 10/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    
    //1. Keep a copy of the dictionary we used to create the user initially as a property in the User.
    // For user persistance
    var dictionary: [String: Any]?
    
    //3. Create a static stored property for _current which will do all work in the back
    private static var _current: User?
    
    //4. Create a static computed property, current that updates the stored _current property as well as saves and retrieves the current user to UserDefaults.
    
    //This property will be set equal to _current and just represents the private _current
    static var current: User? {
        get {
            //_current is always nil at the start app but
            if _current == nil {
                print("In User CLass _current == nil: \(String(describing: _current))")
                //if user defaults has data then create dict with that and create new User
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                    print("In User Class Under get current adding defaults.data UserDefaults")
                }
            }
            //if UserDefaults was not empty it returns a user otherwise returns nil
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
                print("In User Class Under set current User set current User to UserDefaults")
            } else {
                print("In User Class Under set current User removeObject UserDefaults")
                //if user is nil meaning no user encounter then erase it
                //User.current is going to equal to nil when user logs out and
                //UserDefault will be remove
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(dictionary: [String : Any]){
        //super.init()
        //2. Create initializer with dictionary
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
    }
}
