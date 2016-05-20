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
    typealias CompletionEventInit = (eventUrl: String?, error: String?) -> ()
    
    // MARK: Properties
    
    // shared instance
    
    static let sharedInstance = DiscoveryNetworkManager()
    
    // url configuration
    
    static let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    // url session
    
    let session = NSURLSession(configuration: config)
    
    // MARK: Initialization
    
    // private init because its singleton
    
    private init() {}
    
    // MARK: API Calls
    
    // get events with text
    
    func fetchEvents(withKeyword keyword: String, completion: CompletionEvent) {
        let endpoint: String = "https://app.ticketmaster.com/discovery/v1/events.json?apikey=WaPwayOHGN4PCY1EieuT2nCM5H8tufYf&keyword=" +
                                                                    keyword.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        guard let url = NSURL(string: endpoint) else {
            completion(events: nil, error: "Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
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
                    
                    // set image urls for each event in events array
                    
                    for i in 0 ..< events.count {
                        DiscoveryNetworkManager.sharedInstance.fetchEventImageUrlById(events[i].id) {
                            (result, error) -> () in
                            
                            guard error == nil else {
                                // error
                                return
                            }
                            
                            if let result = result {
                                events[i].imageUrl = result
                                dispatch_async(dispatch_get_main_queue(), {
                                    completion(events: events, error: nil)
                                })
                            }
                        }
                    }
                
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
    
    func fetchEventImageUrlById(id: String, completion: CompletionEventInit) {
        let endpoint: String = "https://app.ticketmaster.com/discovery/v1/events/" +
                                                                        id.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())! +
                                                                        "/images.json?apikey=WaPwayOHGN4PCY1EieuT2nCM5H8tufYf"
        
        guard let url = NSURL(string: endpoint) else {
            completion(eventUrl: nil, error: "Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(eventUrl: nil, error: "error calling GET on /discovery/v1 w/error code: \(error!.code)")
                return
            }
            // make sure there's data
            guard let responseData = data else {
                completion(eventUrl: nil, error: "Error: did not receive data")
                return
            }
            // parse result as JSON
            do {
                guard let object = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    completion(eventUrl: nil, error: "error trying to convert data to JSON")
                    return
                }
                
                // access event image url
                if let imageUrl = object["images"] as? [AnyObject] {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(eventUrl: imageUrl[0]["url"] as? String, error: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(eventUrl: nil, error: "No image url")
                    })
                }
            } catch  {
                completion(eventUrl: nil, error: "error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
}