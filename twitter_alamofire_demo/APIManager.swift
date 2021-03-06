//
//  APIManager.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 4/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import KeychainAccess

var limit: Int = 0//will keep track of posts request for infinite scrolling and refresh
class APIManager: SessionManager {
    
    // Get these API by creating an account with https://developer.twitter.com/en/apps/
    /*
     static let consumerKey = "x"//(My-API_KEY)
     static let consumerSecret = "x"//(My API secret key)
     */
    static let consumerKey = "uFTmFW66AAMEUwx3rZlZDMSCf"//"ZJQWm33z9gKKErLTBlFJsVJoI"//(My-API_KEY)
    static let consumerSecret = "LtlxIoQpBvHcqjpSMIA9Gs2E9wCJbr7xkx9EpSdBYoNedaZUgh"//"ssYeCiDopq2yebj1wu0N8aOUNFPJWOBHXAWPGSYN6rK2o1OEWL"//(My API secret key)

    //These are for codepath Twitter Demo, yours look different
    static let requestTokenURL = "https://api.twitter.com/oauth/request_token"
    static let authorizeURL = "https://api.twitter.com/oauth/authorize"
    static let accessTokenURL = "https://api.twitter.com/oauth/access_token"
    
    static let callbackURLString = "alamoTwitter://"
    
    // MARK: Twitter API methods
    func login(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        
        // Add callback url to open app when returning from Twitter login on web
        let callbackURL = URL(string: APIManager.callbackURLString)!
        oauthManager.authorize(withCallbackURL: callbackURL, success: { (credential, _response, parameters) in
            
            // Save Oauth tokens
            self.save(credential: credential)
            
            self.getCurrentAccount { (user, error) in
                if let error = error {
                    print("Que error? : ")
                    failure(error)
                } else if let user = user {
                    User.current = user//used to set current user, from a static func
                    print("In APIManager login func Welcome \(String(describing: user.name))")
                    
                    // MARK: TODO: set User.current, so that it's persisted
                    
                    success()
                }
            }
        }) { (error) in
            failure(error)
        }
    }
    

    func getCurrentAccount(completion: @escaping (User?, Error?) -> ()) {
        request(URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    completion(nil, error)
                    break;
                case .success:
                    guard let userDictionary = response.result.value as? [String: Any] else {
                        completion(nil, JSONError.parsing("Unable to create user dictionary"))
                        return
                    }
                    completion(User(dictionary: userDictionary), nil)
                }
        }
    }
        
    func getHomeTimeLine(completion: @escaping ([Tweet]?, Error?) -> ()) {

        // This uses tweets from disk to avoid hitting 15min rate limit of 15 posts. Comment out if you want fresh tweets
        if let data = UserDefaults.standard.object(forKey: "hometimeline_tweets") as? Data {
            //This will contain each tweet info and on print it'll display info like it did with the movies and tumblr project, all the info many things
            let tweetDictionaries = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String: Any]]
            print("tweetDictionaries")
            print(tweetDictionaries)
            //This flatMap will extract each item of array and make it a Tweet which will
            //only save things we need from the Tweet class and return that Tweet 1 by 1
            //then tweets will contain an array of Tweets with info we only need
            let tweets = tweetDictionaries.flatMap({ (dictionary) -> Tweet in
                Tweet(dictionary: dictionary)
            })
            print("Tweets")
            print(tweets)
            completion(tweets, nil)
            return
        }
        
        limit += 20
        let parameters = ["count": limit]
        request(URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!,  method: .get, parameters: parameters as Parameters)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completion(nil, error)
                    return
                case .success:
                    guard let tweetDictionaries = response.result.value as? [[String: Any]] else {
                        print("Failed to parse tweets")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to parse tweets"])
                        completion(nil, error)
                        return
                    }

                    let data = NSKeyedArchiver.archivedData(withRootObject: tweetDictionaries)
                    UserDefaults.standard.set(data, forKey: "hometimeline_tweets")
                    UserDefaults.standard.synchronize()

                    let tweets = tweetDictionaries.flatMap({ (dictionary) -> Tweet in
                        Tweet(dictionary: dictionary)
                    })
                    completion(tweets, nil)
                }
        }
    }//getHomeTimeLine()
    
    func favoriteOrRetweet(_ tweet: Tweet, _ urlString: String, completion: @escaping (Tweet?, Error?) -> ()) {
        //let urlString = "https://api.twitter.com/1.1/favorites/create.json"
        let parameters = ["id": tweet.id]
        request(urlString, method: .post, parameters: parameters as Parameters, encoding: URLEncoding.queryString).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let tweetDictionary = response.result.value as? [String: Any] {
                let tweet = Tweet(dictionary: tweetDictionary)
                completion(tweet, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    //Get
    func get_id_of_retweet(_ urlString: String, completion: @escaping (Tweet?, Error?) -> ()) {
        
        request(urlString, method: .get, encoding: URLEncoding.queryString).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let tweetDictionary = response.result.value as? [String: Any] {
                let tweet = Tweet(dictionary: tweetDictionary)
                completion(tweet, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    static func logOut() {
        // 1. Clear current user
        User.current = nil
        
        print("In APIManager setting User.current = nil Logout notification received")
        
        // TODO: 2. Deauthorize OAuth tokens
        
        // 3. Post logout notification
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    // MARK: TODO: Favorite a Tweet
    
    // MARK: TODO: Un-Favorite a Tweet
    
    // MARK: TODO: Retweet
    
    // MARK: TODO: Un-Retweet
    
    // MARK: TODO: Compose Tweet
    
    // MARK: TODO: Get User Timeline
    
    
    //--------------------------------------------------------------------------------//
    
    
    //MARK: OAuth
    static var shared: APIManager = APIManager()
    
    var oauthManager: OAuth1Swift!
    
    // Private init for singleton only
    private init() {
        super.init()
        
        // Create an instance of OAuth1Swift with credentials and oauth endpoints
        oauthManager = OAuth1Swift(
            consumerKey: APIManager.consumerKey,
            consumerSecret: APIManager.consumerSecret,
            requestTokenUrl: APIManager.requestTokenURL,
            authorizeUrl: APIManager.authorizeURL,
            accessTokenUrl: APIManager.accessTokenURL
        )
        
        // Retrieve access token from keychain if it exists
        if let credential = retrieveCredentials() {
            oauthManager.client.credential.oauthToken = credential.oauthToken
            oauthManager.client.credential.oauthTokenSecret = credential.oauthTokenSecret
        }
        
        // Assign oauth request adapter to Alamofire SessionManager adapter to sign requests
        adapter = oauthManager.requestAdapter
    }
    
    // MARK: Handle url
    // OAuth Step 3
    // Finish oauth process by fetching access token
    func handle(url: URL) {
        OAuth1Swift.handle(url: url)
    }
    
    // MARK: Save Tokens in Keychain
    private func save(credential: OAuthSwiftCredential) {
        
        // Store access token in keychain
        let keychain = Keychain()
        let data = NSKeyedArchiver.archivedData(withRootObject: credential)
        keychain[data: "twitter_credentials"] = data
    }
    
    // MARK: Retrieve Credentials
    private func retrieveCredentials() -> OAuthSwiftCredential? {
        let keychain = Keychain()
        
        if let data = keychain[data: "twitter_credentials"] {
            let credential = NSKeyedUnarchiver.unarchiveObject(with: data) as! OAuthSwiftCredential
            return credential
        } else {
            return nil
        }
    }
    
    // MARK: Clear tokens in Keychain
    private func clearCredentials() {
        // Store access token in keychain
        let keychain = Keychain()
        do {
            try keychain.remove("twitter_credentials")
        } catch let error {
            print("error: \(error)")
        }
    }
}

enum JSONError: Error {
    case parsing(String)
}
