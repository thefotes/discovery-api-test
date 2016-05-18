//
//  DiscoveryTableViewCell.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/17/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

final class DiscoveryTableViewCell: UITableViewCell, TableViewCellReusable {
    
    // MARK: Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configureWithEvent(event: Event) {
        nameLabel.text = event.name
    }

}
