//
//  RestaurantData.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import Foundation

/* Names of the following properties are the exact same as the names of the keys in the JSON file
 retrieved using the Zomato API.
*/

struct RestaurantData: Decodable {
    let restaurants: [ApiMiddleMan]
}

struct ApiMiddleMan: Decodable {
    let restaurant: RestaurantRawData
}

struct RestaurantRawData: Decodable {
    let id: String
    let name: String
    let currency: String
    let timings: String
    let average_cost_for_two: Int
    let cuisines: String
    let url: String
    let location: Location
    let user_rating: Rating
    
    public func getRating() -> String {
        if user_rating.aggregate_rating is Int {
            return "NR"
        } else {
            return user_rating.aggregate_rating as! String
        }
    }
    
    public func getVotes() -> String {
        if user_rating.votes is Int {
            return "0"
        } else {
            return user_rating.votes as! String
        }
        
    }
    
}

struct Location: Decodable {
    let latitude: String
    let longitude: String
    let address: String
    let locality_verbose: String
    let city: String
}

/*
 The code for the Rating struct is based on this article by Sergio Schechtman Sette
 https://medium.com/grand-parade/parsing-fields-in-codable-structs-that-can-be-of-any-json-type-e0283d5edb
 */

struct Rating: Decodable {
    let aggregate_rating: Any
    let votes: Any
    var rating_color: String = ""
    
    enum CodingKeys: String, CodingKey {
        case aggregate_rating
        case votes
        case rating_color
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let color = try? container.decode(String.self, forKey: .rating_color) {
                rating_color = color
            }
            
            // Dynamic properties are aggregate_rating and votes (Either an Int (value always 0) or String
            if let stringPropertyRating = try? container.decode(String.self, forKey: .aggregate_rating), let stringPropertyVoting = try? container.decode(String.self, forKey: .votes){
                aggregate_rating = stringPropertyRating
                votes = stringPropertyVoting
            } else if let intPropertyRating = try? container.decode(Int.self, forKey: .aggregate_rating), let intPropertyVoting = try? container.decode(Int.self, forKey: .votes) {
                aggregate_rating = intPropertyRating
                votes = intPropertyVoting
            } else if let stringPropertyRating = try? container.decode(String.self, forKey: .aggregate_rating), let intPropertyVoting = try? container.decode(Int.self, forKey: .votes) {
                aggregate_rating = stringPropertyRating
                votes = intPropertyVoting
            } else {
                aggregate_rating = "NA"
                votes = "0"
                rating_color = "#383a3d"
            }
        } catch {
            aggregate_rating = "NA"
            votes = "0"
            rating_color = "#383a3d"
            print(error)
        }
    }
}
