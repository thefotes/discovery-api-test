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
    var imageUrl: String?
    
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
    
    func setDate(date: String) -> String {
        let dateComponents = NSDateComponents()
        dateComponents.year = Int(date.substringWithRange(Range<String.Index>(date.startIndex..<date.endIndex.advancedBy(-24))))!
        dateComponents.month = Int(date.substringWithRange(Range<String.Index>(date.startIndex.advancedBy(5)..<date.endIndex.advancedBy(-21))))!
        dateComponents.day = Int(date.substringWithRange(Range<String.Index>(date.startIndex.advancedBy(8)..<date.endIndex.advancedBy(-18))))!
        dateComponents.hour = Int(date.substringWithRange(Range<String.Index>(date.startIndex.advancedBy(11)..<date.endIndex.advancedBy(-15))))!
        dateComponents.minute = Int(date.substringWithRange(Range<String.Index>(date.startIndex.advancedBy(14)..<date.endIndex.advancedBy(-12))))!
        dateComponents.second = Int(date.substringWithRange(Range<String.Index>(date.startIndex.advancedBy(17)..<date.endIndex.advancedBy(-9))))!
        let dateFromComponents = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        // NSDateFormatter
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(dateFromComponents!)
    }
}
