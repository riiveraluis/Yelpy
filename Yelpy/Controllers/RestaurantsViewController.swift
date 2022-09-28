//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage
import Lottie
import SkeletonView

class RestaurantsViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    // Initializers
    var restaurantsArray: [Restaurant] = []
    var filteredRestaurants: [Restaurant] = []
    
    // –––––  Lab 4: create an animation view
    var animationView: AnimationView?
    var refresh = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ––––– Lab 4 TODO: Start animations
        startAnimation()
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // Search Bar delegate
        searchBar.delegate = self
        
        // Get Data from API
        getAPIData()
        
        // –––––  Lab 4: stop animations, you can add a timer to stop the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: self.stopAnimation)
    }
    
    
    @objc func getAPIData() {
        API.getRestaurants() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.restaurantsArray = restaurants
            self.filteredRestaurants = restaurants
            self.tableView.reloadData()
        }
    }
}

// ––––– TableView Functionality –––––
extension RestaurantsViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "RestauranCell"
    }
    
    func startAnimation() {
        animationView = .init(name: "4762-food-carousel")
        animationView?.frame = CGRect(x: view.frame.width / 3, y: 0, width: 100, height: 100)
        animationView?.contentMode = .scaleAspectFit
        view.addSubview(animationView!)
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1
        animationView?.play()
        view.showGradientSkeleton()
    }
    
    @objc func stopAnimation() {
//        animationView?.stop()
        view.hideSkeleton()
//        view.subviews.last?.removeFromSuperview()
        view.hideSkeleton()
        refresh = false
    }
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        
        cell.r = filteredRestaurants[indexPath.row]
        
        if self.refresh {
            cell.showAnimatedSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let r = filteredRestaurants[indexPath.row]
            let detailViewController = segue.destination as! RestaurantDetailViewController
            detailViewController.r = r
        }
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    
    // Search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredRestaurants = restaurantsArray.filter { (r: Restaurant) -> Bool in
                return r.name.lowercased().contains(searchText.lowercased())
            }
        }
        else {
            filteredRestaurants = restaurantsArray
        }
        tableView.reloadData()
    }
    
    
    // Show Cancel button when typing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    // Logic for searchBar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false // remove cancel button
        searchBar.text = "" // reset search text
        searchBar.resignFirstResponder() // remove keyboard
        filteredRestaurants = restaurantsArray // reset results to display
        tableView.reloadData()
    }
    
}





