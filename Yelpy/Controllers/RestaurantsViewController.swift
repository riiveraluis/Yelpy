//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!
    
    // ––––– TODO: Build Restaurant Class Done
    
    // –––––– TODO: Update restaurants Array to an array of Restaurants Done
    var restaurantsArray: [Restaurant] = []
    
    // Bonus
    
    var searchController: UISearchController!
    
    var filteredPlaces: [Restaurant]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredPlaces = []
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        getAPIData()
        
        tableView.reloadData()
    }
    
    
    // ––––– TODO: Update API to get an array of restaurant objects Done
    func getAPIData() {
        API.getRestaurants() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.restaurantsArray = restaurants
            self.filteredPlaces = restaurants
            
            self.tableView.reloadData()
        }
    }
    
    // Protocol Stubs
    // How many cells there will be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
    
    
    // ––––– TODO: Configure cell using MVC
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Restaurant Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        
        let restaurant = filteredPlaces[indexPath.row]
        
        cell.r = restaurant
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredPlaces = searchText.isEmpty ? restaurantsArray
            :
            restaurantsArray.filter { $0.name.localizedCaseInsensitiveContains(searchText)
            }
            tableView.reloadData()
        }
    }
    
    // –––––– TODO: Override segue to pass the restaurant object to the DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        if let indexpath = tableView.indexPath(for: cell) {
            let r = restaurantsArray[indexpath.row]
            let detailViewController = segue.destination as! RestaurantDetailViewController
            detailViewController.r = r
        }
    }
}
