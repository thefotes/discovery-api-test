//
//  DiscoveryTableViewController.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/17/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

final class DiscoveryTableViewController: UITableViewController, UISearchBarDelegate {
    
    // Mark: Properties
    
    var events = [Event]()
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        // call api
        
        DiscoveryNetworkManager.getRecentEventsIntoConsole()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(DiscoveryTableViewCell.reIdentifier, forIndexPath: indexPath) as! DiscoveryTableViewCell
        
        // Return appropriate event
        
        let event = events[indexPath.row]
        dequeuedCell.configureWithEvent(event)

        return dequeuedCell
    }

}
