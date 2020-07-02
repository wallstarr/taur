//
//  RestaurantManager.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation

protocol RestaurantManagerDelegate {
    func didUpdateRestaurants(_ restaurantManager: RestaurantManager, restaurants: [Restaurant])
    func didFailWithError(error: Error)
}

struct RestaurantManager {
    public static let NUMOFRESTAURANTS: Int = 20
    
    fileprivate var baseURLForLocation =  "https://developers.zomato.com/api/v2.1/search?count=25&sort=real_distance&apikey=YOUR-API-KEY-HERE"
    
    public var delegate: RestaurantManagerDelegate?
    
    public func fetchPlaces(latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        let restaurantsURL = "\(String(describing: baseURLForLocation))&lat=\(lat)&lon=\(lon)"
        print(restaurantsURL)
        performRequest(with: restaurantsURL)
    }
    
    fileprivate func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let restaurants = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRestaurants(self, restaurants: restaurants)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    fileprivate func parseJSON(_ data: Data) -> [Restaurant]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RestaurantData.self, from: data)
            var restaurants: [Restaurant] = []
            for r in decodedData.restaurants {
                let newRestaurant = Restaurant(id: r.restaurant.id, name: r.restaurant.name, currency: r.restaurant.currency, timings: r.restaurant.timings, cuisines: r.restaurant.cuisines, url: r.restaurant.url, latitude: r.restaurant.location.latitude, longitude: r.restaurant.location.longitude, address: r.restaurant.location.address, locality: r.restaurant.location.locality_verbose, city: r.restaurant.location.city, rating: r.restaurant.getRating(), numOfVotes: r.restaurant.getVotes(), ratingColour:  r.restaurant.user_rating.rating_color)
                restaurants.append(newRestaurant)
            }
            return restaurants
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
