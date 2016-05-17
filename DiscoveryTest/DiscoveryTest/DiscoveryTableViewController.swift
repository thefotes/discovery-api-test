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
    
    var eventDataArray: [[String: AnyObject]] = []
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        indicator.center = view.center
        view.addSubview(indicator)
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
        return eventDataArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // cell identifier
        
        let cellIdentifier = "DiscoveryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DiscoveryTableViewCell
        
        // return appropriate event
        
        let event = eventDataArray[indexPath.row]
        cell.nameLabel.text = (event["name"] as! String)

        return cell
    }
    
    // Mark: Handling API Request
    
    func setEventArrayWithKeyword(keyword: String) {
        
        // create endpoint
        let endpoint: String = "https://app.ticketmaster.com/discovery/v1/events.json?apikey=WaPwayOHGN4PCY1EieuT2nCM5H8tufYf" + "&keyword=" + keyword
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
                
                // set property to event array
                
                if let temp = object["_embedded"]?["events"] as? [[String: AnyObject]] {
                    self.eventDataArray = temp
                    
                    // reload table view
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                    })
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    // Mark: Search Functionality
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // start indicator
        
        indicator.startAnimating()
        
        // assuming not empty text field
        
        setEventArrayWithKeyword(searchBar.text!)
    }

}
