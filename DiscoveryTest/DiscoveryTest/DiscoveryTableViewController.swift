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
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
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
        if !events.isEmpty {
            let event = events[indexPath.row]
            dequeuedCell.configureWithEvent(event)
        }

        return dequeuedCell
    }
    
    // MARK: Search Functionality
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // resign first responder
        
        searchBar.resignFirstResponder()
        
        // assuming not empty text field
        
        SVProgressHUD.show()
        
        DiscoveryNetworkManager.sharedInstance.fetchEvents(withKeyword: searchBar.text!) {
            (result, error) -> () in
            
            SVProgressHUD.dismiss()
            
            guard error == nil else {
                // Alert user of error
                
                let alertController = UIAlertController(title: "Error", message: error!, preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alertController.addAction(okButton)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.events = result
            self.tableView.reloadData()
        }
    }

}
