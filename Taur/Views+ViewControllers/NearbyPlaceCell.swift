//
//  NearbyPlaceCell.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import UIKit

class NearbyPlaceCell: UITableViewCell {
    
    public static let IDENTIFIER = "NearbyPlaceCell"
    
    fileprivate var restaurant: Restaurant?
    fileprivate var restaurantName = UILabel()
    fileprivate var restaurantRating = UILabel()
    fileprivate var restaurantType = UILabel()
    
    let ratingOffScreenAmount: CGFloat = 15.0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setRestaurant(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        if let safeRestaurant = self.restaurant {
            restaurantName.text = safeRestaurant.name
            restaurantType.text = restaurant.cuisines
            restaurantRating.text = restaurant.rating
            if let restaurantRatingAsString = restaurantRating.text {
                if let restaurantRatingAsNum = Double(restaurantRatingAsString) {
                    if restaurantRatingAsNum >= 4.0 {
                        restaurantRating.shadowOffset = CGSize(width: 2, height: 2)
                    }
            }
            restaurantRating.textColor = HexToUIColor.hexToUIColor(restaurant.ratingColour)
            }
        }
    }
    
    fileprivate func setupViews() {
        backgroundColor = UIColor(named: "BackgroundColor")
        addSubview(restaurantName)
        addSubview(restaurantRating)
        addSubview(restaurantType)
        setRatingConstraints()
        setNameConstraints()
        setTypeConstraints()
    }
    
    fileprivate func setRatingConstraints() {
        restaurantRating.translatesAutoresizingMaskIntoConstraints = false
        restaurantRating.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        restaurantRating.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ratingOffScreenAmount).isActive = true
        restaurantRating.font = UIFont.boldSystemFont(ofSize: 22)
        restaurantRating.shadowColor = .black
        restaurantRating.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    fileprivate func setNameConstraints() {
        restaurantName.translatesAutoresizingMaskIntoConstraints = false
        restaurantName.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -9).isActive = true
        restaurantName.leftAnchor.constraint(equalTo: restaurantRating.rightAnchor, constant: ratingOffScreenAmount).isActive = true
        restaurantName.font = UIFont.boldSystemFont(ofSize: 19)
        restaurantName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
        restaurantName.adjustsFontSizeToFitWidth = false
    }
    
    fileprivate func setTypeConstraints() {
        restaurantType.translatesAutoresizingMaskIntoConstraints = false
        restaurantType.topAnchor.constraint(equalTo: restaurantName.bottomAnchor, constant: 0).isActive = true
        restaurantType.leftAnchor.constraint(equalTo: restaurantRating.rightAnchor, constant: ratingOffScreenAmount).isActive = true
        restaurantType.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
        restaurantType.adjustsFontSizeToFitWidth = true
        restaurantType.textColor = .darkGray
        restaurantType.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }

    
}
