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
    
    init?(withDictionary dictionary: [String: AnyObject]) {
        guard let name = dictionary["name"] as? String, let locale = dictionary["locale"] as? String, let eventUrl = dictionary["eventUrl"] as? String,
                let test = dictionary["test"] as? Bool, let id = dictionary["id"] as? String, let type = dictionary["type"] as? String else {
                    print("Error initializing event")
                    return nil
        }
        self.name = name
        self.locale = locale
        self.eventUrl = eventUrl
        self.test = test
        self.id = id
        self.type = type
    }
}
