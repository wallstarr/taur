//
//  RestaurantInfoVC.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurantInfoVC: UIViewController {
    
    var restaurant: Restaurant?
    var nameLabel = UILabel()
    var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
        
    }
    
    public func setRestaurant(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        nameLabel.text = restaurant.name
        setLocation()
        
    }
    
    fileprivate func setLocation() {
        if let safeLatitude = restaurant?.latitude, let safeLongitude = restaurant?.longitude {
            if let latitude = Double(safeLatitude), let longitude = Double(safeLongitude) {
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 100, longitudinalMeters: 100)
                mapView.setRegion(region, animated: false)
                let restaurantAnnotation = MKPointAnnotation()
                restaurantAnnotation.title = restaurant?.name
                restaurantAnnotation.coordinate = coordinates
                mapView.addAnnotation(restaurantAnnotation)
                print(latitude)
                print(longitude)
                print(restaurant?.address)
                
            }
        }
    }
    
    fileprivate func configureViews() {
        view.addSubview(nameLabel)
        view.addSubview(mapView)
        configureMapView()
        configureTitle()
    }
    
    fileprivate func configureMapView() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (-2 * screenHeight) / 3.3).isActive = true
        mapView.layer.cornerRadius = 10
    }
    
    fileprivate func configureTitle() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 7).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    
}

