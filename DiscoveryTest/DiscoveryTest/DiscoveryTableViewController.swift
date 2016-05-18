//
//  DiscoveryTableViewController.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/17/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

final class DiscoveryTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: Properties
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        indicator.center = view.center
        view.addSubview(indicator)
    }

    // MARK: Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(DiscoveryTableViewCell.reuseableIdentifier, forIndexPath: indexPath) as! DiscoveryTableViewCell
        
        // return appropriate event
        
        let event = events[indexPath.row]
        dequeuedCell.configureWithEvent(event)

        return dequeuedCell
    }
    
    // MARK: Search Functionality
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // start indicator
        
        indicator.startAnimating()
        
        // assuming not empty text field
        
        DiscoveryNetworkManager.sharedInstance.setEvents(withKeyword: searchBar.text!) {
            (result) -> () in
            self.events = result
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }

}
