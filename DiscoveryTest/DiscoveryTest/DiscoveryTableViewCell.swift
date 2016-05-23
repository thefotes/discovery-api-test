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
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var ticketmasterImageView: UIImageView!
    
    func configureWithEvent(event: Event) {
        nameLabel.text = event.name
        nameLabel.numberOfLines = 0
        dateLabel.text = event.date
        if let imageUrl = event.imageUrl {
            ticketmasterImageView.sd_setImageWithURL(NSURL(string: imageUrl))
        }
    }
}
