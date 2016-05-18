//
//  DiscoveryNetworkManager.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/18/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import Foundation


final class DiscoveryNetworkManager {
    
    // shared instance
    
    private let sharedInstance = DiscoveryNetworkManager()
    
    // private init because its singleton
    
    private init() {}
    
    // get most recent events
    
    static func getRecentEventsIntoConsole() {
        let endpoint: String = "https://app.ticketmaster.com/discovery/v1/events.json?apikey=WaPwayOHGN4PCY1EieuT2nCM5H8tufYf"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /discovery/v1")
                print(error)
                return
            }
            // make sure there's data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse result as JSON
            do {
                guard let object = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // print object
                //print("Here is the object: " + object.description)
                
                // access event names
                let eventArray = object["_embedded"]!["events"] as! [[String: AnyObject]]
                
                for event in eventArray {
                    print("*********************************************************************************************")
                    print(event["name"]!)
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
}