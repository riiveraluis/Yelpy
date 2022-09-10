//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // ––––– TODO: Add storyboard Items (i.e. tableView + Cell + configurations for Cell + cell outlets)
    // ––––– TODO: Next, place TableView outlet here
    @IBOutlet weak var tableView: UITableView!
    
    // –––––– TODO: Initialize restaurantsArray
    var restaurants: [[String:Any?]] = []
    
    
    // ––––– TODO: Add tableView datasource + delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getAPIData()
    }
    
    
    // ––––– TODO: Get data from API helper and retrieve restaurants
    func getAPIData() {
        API.getRestaurants { restaurants in
            guard let restaurants = restaurants else { return }
            print(restaurants)
            self.restaurants = restaurants
            self.tableView.reloadData()
        }
    }
    
}

// ––––– TODO: Create tableView Extension and TableView Functionality

extension RestaurantsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! RestaurantCell
        
        let restaurant = restaurants[indexPath.row]
        
        cell.restaurantTitleLabel.text = restaurant["name"] as? String ?? ""
        let restaurantCategories = restaurant["categories"] as? [[String: Any]]
        let category = restaurantCategories![0]
        cell.categoryLabel.text = category["title"] as? String
        cell.costLabel.text = restaurant["price"] as? String ?? "Price Info Unavailable"
        
        let rating = restaurant["rating"] as? Double ?? 0.0
        cell.ratingsImageView.image = getStars(from: rating)
        cell.ratingsLabel.text = String(restaurant["review_count"] as? Int ?? 0)
        
        cell.phoneNumberLabel.text = restaurant["display_phone"] as? String
        
        if let imageURLString = restaurant["image_url"] as? String {
            let imageURL = URL(string: imageURLString)
            cell.restaurantImage.af.setImage(withURL: imageURL!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getStars(from rating: Double) -> UIImage {
        switch rating {
        case 0.0:
            return UIImage(named: "regular_0")!
        case 1.0:
            return UIImage(named: "regular_1")!
        case 1.5:
            return UIImage(named: "regular_1_half")!
        case 2.0:
            return UIImage(named: "regular_2")!
        case 2.5:
            return UIImage(named: "regular_2_half")!
        case 3.0:
            return UIImage(named: "regular_3")!
        case 3.5:
            return UIImage(named: "regular_3_half")!
        case 4.0:
            return UIImage(named: "regular_4")!
        case 4.5:
            return UIImage(named: "regular_4_half")!
        case 5.0:
            return UIImage(named: "regular_5")!
        default:
            return UIImage(named: "regular_0")!
        }
    }
}
