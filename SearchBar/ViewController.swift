//
//  ViewController.swift
//  SearchBar
//
//  Created by John Silva on 5/10/15.
//  Copyright (c) 2015 John Silva. All rights reserved.
//

import UIKit

let API1 = "http://restcountries.eu/rest/v1/all"

class ViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    // MARK:
    // MARK: constantes e variáveis
    @IBOutlet var table: UITableView!
    
    var tableData: NSMutableArray = NSMutableArray()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    // MARK:
    // MARK: view delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.getData()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.tintColor = UIColor.redColor()
            controller.searchBar.barStyle = UIBarStyle.Black
            //controller.searchBar.searchBarStyle = UISearchBarStyle.Minimal
            
            self.table.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.table.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:
    // MARK: table view datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // 3
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row] as? String
            
            return cell
        }
    }
    
    // MARK:
    // MARK: search results
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        
        self.table.reloadData()
    }
    
    // MARK:
    // MARK: methods
    func getData() {
        let url: NSURL = NSURL(string: API1)!
        let data: NSData = NSData(contentsOfURL: url)!
        var error: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as! NSArray
        
        if (error == nil) {
            
            for (var i = 0; i<json.count; i++) {
                var capital:AnyObject = json.objectAtIndex(i).objectForKey("capital")!
                var name:AnyObject = json.objectAtIndex(i).objectForKey("name")!
                var region:AnyObject = json.objectAtIndex(i).objectForKey("region")!
                tableData.insertObject(name, atIndex: i)
            }
            println("JSON: \n\(tableData)")
        }else {
            println("ERROR: \n\(error)")
        }
        
    }

}

