//
//  NearbyPlacesVC.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import UIKit
import MapKit

class NearbyPlacesVC: UIViewController {

    var tableView = UITableView()
    var restaurantManager = RestaurantManager()
    var locationManager = CLLocationManager()
    var restaurants: [Restaurant] = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(named: "AccentColor")
        tableView.separatorColor = UIColor(named: "")
        title = "Near You \(getRandomFoodEmoji())"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pin(to: view)
        tableView.rowHeight = 80
        tableView.register(NearbyPlaceCell.self, forCellReuseIdentifier: NearbyPlaceCell.IDENTIFIER)
    }
    
    private func getRandomFoodEmoji() -> String {
        let emojiArray = ["🍜", "☕", "🌯", "🥙", "🍛", "🍝", "🥡"]
        return emojiArray.randomElement() ?? ""
    }
}

extension NearbyPlacesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantManager.NUMOFRESTAURANTS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NearbyPlaceCell.IDENTIFIER) as! NearbyPlaceCell
        if restaurants.count > indexPath.row {
            cell.setRestaurant(restaurants[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
       indexPath: IndexPath) {
        let restaurantInfo = RestaurantInfoVC()
        restaurantInfo.setRestaurant(restaurants[indexPath.row])
        self.navigationController?.pushViewController(restaurantInfo, animated: true)
        
    }
}

extension NearbyPlacesVC: RestaurantManagerDelegate {
    func didUpdateRestaurants(_ restaurantManager: RestaurantManager, restaurants: [Restaurant]) {
        self.restaurants = restaurants
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.animateCells(
                cells: self.tableView.visibleCells,
              duration: 0.3,
              delay: 0.1,
              dampingRatio: 0.8,
              configure: { cell -> (prepare: () -> Void, animate: () -> Void)? in
                guard let customCell = cell as? NearbyPlaceCell else { return nil }
                let preparations = {
                  customCell.alpha = 0
                }
                let animations = {
                  customCell.alpha = 1
                }
                return (preparations, animations)
            })
            self.tableView.endUpdates()
        }
    }
    
    func didFailWithError(error: Error) {
//        if (error is DecodingError) {
//            print(error)
//        }
        print(error)
    }
}

extension NearbyPlacesVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            restaurantManager.fetchPlaces(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
