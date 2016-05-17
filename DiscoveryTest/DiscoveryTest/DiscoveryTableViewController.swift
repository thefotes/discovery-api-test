//
//  DiscoveryTableViewController.swift
//  DiscoveryTest
//
//  Created by Jason Chitla on 5/17/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

class DiscoveryTableViewController: UITableViewController, UISearchBarDelegate {
    
    // Mark: Properties
    
    var events = [Event]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        // Load sample data
        
        loadSampleEvents()
        
        callJSON()
    }
    
    func loadSampleEvents() {
        let event1 = Event(name: "Wiz Khalifa Concert")
        let event2 = Event(name: "Taylor Swift Concert")
        let event3 = Event(name: "Jason Aldean Concert")
        
        events += [event1, event2, event3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Cell identifier
        
        let cellIdentifier = "DiscoveryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DiscoveryTableViewCell
        
        // Return appropriate event
        
        let event = events[indexPath.row]
        cell.nameLabel.text = event.name

        return cell
    }
    
    // Mark: Handling API Request
    
    func callJSON() {
        let endpoint: String = "https://app.ticketmaster.com/discovery/v1/events.json?apikey=WaPwayOHGN4PCY1EieuT2nCM5H8tufYf"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /discovery/v1")
                print(error)
                return
            }
            // make sure there's data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse result as JSON
            do {
                guard let object = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // print object
                //print("Here is the object: " + object.description)
                
                // access event names
                let eventArray = object["_embedded"]!["events"] as! [[String: AnyObject]]
                
                for event in eventArray {
                    print("*********************************************************************************************")
                    print(event["name"]!)
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }

}
