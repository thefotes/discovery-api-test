//
//  Protocols.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/18/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

protocol TableViewCellReusable {
    static var reIdentifier: String { get }
}

extension TableViewCellReusable where Self: UITableViewCell {
    static var reIdentifier: String {
        return String(self).componentsSeparatedByString(".").last!
    }
}