//
//  Event.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/17/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import Foundation

struct Event {
    let name: String
    let locale: String
    let eventUrl: String
    let test: Bool
    let id: String
    let type: String
    var date: String?
    var imageUrl: NSURL?
    
    init?(withDictionary dictionary: [String: AnyObject]) {
        guard let name = dictionary["name"] as? String, let locale = dictionary["locale"] as? String, let eventUrl = dictionary["eventUrl"] as? String,
                let test = dictionary["test"] as? Bool, let id = dictionary["id"] as? String, let type = dictionary["type"] as? String,
                let rawDate = (dictionary["dates"]?["start"])?["dateTime"] as? String else {
                    print("Error initializing event")
                    return nil
        }
        self.name = name
        self.locale = locale
        self.eventUrl = eventUrl
        self.test = test
        self.id = id
        self.type = type
        
        // set date string
        self.date = setDate(rawDate)
    }
    
    func setDate(date: String) -> String? {
        // create NSDate object from raw date value passed in
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        let dateWithCorrectFormat = formatter.dateFromString(date)
        
        // take the NSDate object, change it to aesthetically pleasing string
        let displayFormatter = NSDateFormatter()
        displayFormatter.dateStyle = .FullStyle
        displayFormatter.timeStyle = .ShortStyle
        
        if let dateWithCorrectFormat = dateWithCorrectFormat {
            return displayFormatter.stringFromDate(dateWithCorrectFormat)
        } else {
            return nil
        }
    }
}
