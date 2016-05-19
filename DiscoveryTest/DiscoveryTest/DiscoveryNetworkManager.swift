//
//  DiscoveryNetworkManager.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/18/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit


final class DiscoveryNetworkManager {
    
    typealias CompletionEvent = (events: [Event]?, error: String?) -> ()
    
    // MARK: Properties
    
    // shared instance
    
    static let sharedInstance = DiscoveryNetworkManager()
    
    // MARK: Initialization
    
    // private init because its singleton
    
    private init() {}
    
    // MARK: API Calls
    
    // get events with text
    
    func returnEvents(withKeyword keyword: String, completion: CompletionEvent) {
        let endpoint: String = "https://app.ticketmaster.com/discovery/v1/events.json?apikey=WaPwayOHGN4PCY1EieuT2nCM5H8tufYf&keyword=" +
                                                                    keyword.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        guard let url = NSURL(string: endpoint) else {
            completion(events: nil, error: "Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(events: nil, error: "error calling GET on /discovery/v1 w/error code: \(error!.code)")
                return
            }
            // make sure there's data
            guard let responseData = data else {
                completion(events: nil, error: "Error: did not receive data")
                return
            }
            // parse result as JSON
            do {
                guard let object = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    completion(events: nil, error: "error trying to convert data to JSON")
                    return
                }
                
                // access event names
                if let eventArray = object["_embedded"]?["events"] as? [[String: AnyObject]] {
                    var events = [Event]()
                    
                    // passes in non-nil Events to events array
                    
                    events = eventArray.flatMap({dictionary in
                        if let event = Event.init(withDictionary: dictionary) {
                            return event
                        } else {
                            return nil
                        }
                    })
                
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(events: events, error: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(events: nil, error: "No events found")
                    })
                }
            } catch  {
                completion(events: nil, error: "error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    
}