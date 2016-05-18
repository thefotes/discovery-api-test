//
//  DiscoveryTableViewCell.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/17/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

final class DiscoveryTableViewCell: UITableViewCell {
    
    // Mark: Properties
    
    @IBOutlet private weak var nameLabel: UILabel!

    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    func configureWithEvent(event: Event) {
        nameLabel.text = event.name
    }

}
