//
//  DiscoveryNetworkManager.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/18/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit


final class DiscoveryNetworkManager {
    
    // MARK: URL Enum
    
    enum URL {
        case fetchEvents(apiKey: String, keyword: String)
        case fetchEventImages(apiKey: String, id: String)
        
        func requestUrl() -> NSURL? {
            switch self {
            case .fetchEvents(let apiKey, let keyword):
                return NSURL(string: "https://app.ticketmaster.com/discovery/v1/events.json?apikey=" + apiKey + "&keyword=" +
                                                                    keyword.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!)
            case .fetchEventImages(let apiKey, let id):
                return NSURL(string: "https://app.ticketmaster.com/discovery/v1/events/" + id.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())! +
                                                        "/images.json?apikey=" + apiKey)
            }
        }
    }
    
    typealias CompletionEvent = (events: [Event], error: String?) -> ()
    typealias FetchEventImageCompletion = (imageUrl: NSURL?, error: String?) -> ()
    
    // MARK: Properties
    
    static let sharedInstance = DiscoveryNetworkManager()
    
    // MARK: Network Configuration
    
    private static let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    private let session = NSURLSession(configuration: sessionConfig)
    private let API_KEY: String = "WaPwayOHGN4PCY1EieuT2nCM5H8tufYf"
    
    // MARK: Initialization
    
    // private init because its singleton
    
    private init() {}
    
    // MARK: API Calls
    
    // get events with text
    
    func fetchEvents(withKeyword keyword: String, completion: CompletionEvent) {
        guard let url = URL.fetchEvents(apiKey: API_KEY, keyword: keyword).requestUrl() else {
            completion(events: [], error: "Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(events: [], error: "error calling GET on /discovery/v1 w/error code: \(error!.code)")
                return
            }
            // make sure there's data
            guard let responseData = data else {
                completion(events: [], error: "Error: did not receive data")
                return
            }
            // parse result as JSON
            do {
                guard let object = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    completion(events: [], error: "error trying to convert data to JSON")
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
                        completion(events: [], error: "No events found")
                    })
                }
            } catch  {
                completion(events: [], error: "error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    func fetchEventImageUrlById(id: String, completion: FetchEventImageCompletion) {
        
        guard let url = URL.fetchEventImages(apiKey: API_KEY, id: id).requestUrl() else {
            completion(imageUrl: nil, error: "Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                completion(imageUrl: nil, error: "error calling GET on /discovery/v1 w/error code: \(error!.code)")
                return
            }
            // make sure there's data
            guard let responseData = data else {
                completion(imageUrl: nil, error: "Error: did not receive data")
                return
            }
            // parse result as JSON
            do {
                guard let object = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    completion(imageUrl: nil, error: "error trying to convert data to JSON")
                    return
                }
                
                // access event image url
                if let imageUrl = object["images"] as? [AnyObject], let string = imageUrl[0]["url"] as? String {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(imageUrl: NSURL(string: string), error: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(imageUrl: nil, error: "No image url")
                    })
                }
            } catch  {
                completion(imageUrl: nil, error: "error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
}