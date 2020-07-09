//
//  RestaurantInfoVC.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class RestaurantInfoVC: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    lazy var screenHeight = screenSize.height
    lazy var screenWidth = screenSize.width
    
    var restaurant: Restaurant?
    var nameLabel = UILabel()
    var mapView = MKMapView()
    var zomatoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(mapView)
        view.addSubview(zomatoButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureViews()
    }
    
    public func setRestaurant(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        setUpRestaurantDetails(restaurant: restaurant)
        setLocation()
    }
    
    fileprivate func setUpRestaurantDetails(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
    }
    
    fileprivate func setLocation() {
        if let safeLatitude = restaurant?.latitude, let safeLongitude = restaurant?.longitude {
            if let latitude = Double(safeLatitude), let longitude = Double(safeLongitude) {
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 150, longitudinalMeters: 150)
                mapView.setRegion(region, animated: false)
                let restaurantAnnotation = MKPointAnnotation()
                restaurantAnnotation.title = restaurant?.name
                restaurantAnnotation.coordinate = coordinates
                mapView.addAnnotation(restaurantAnnotation)
            }
        }
    }
    
    fileprivate func configureViews() {
        configureTitle()
        configureMapView()
        configureZomatoButton()
    }

    fileprivate func configureTitle() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.textAlignment = .center
        nameLabel.widthAnchor.constraint(equalToConstant: screenWidth - 10).isActive = true
    }
    
    fileprivate func configureMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        mapView.layer.cornerRadius = 10
        mapView.showsUserLocation = true
    }
    
    fileprivate func configureZomatoButton() {
        zomatoButton.translatesAutoresizingMaskIntoConstraints = false
        zomatoButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10).isActive = true
        zomatoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        zomatoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        zomatoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        zomatoButton.layer.cornerRadius = 15
        zomatoButton.backgroundColor = .white
        zomatoButton.setImage(UIImage(named: "ZomatoLogo"), for: .normal)
        zomatoButton.imageView?.layer.transform = CATransform3DMakeScale(1.45 , 1.45, 1.45)
        zomatoButton.addTarget(self, action: #selector(zomatoButtonPressed), for: .touchUpInside)
    }
    
    @objc fileprivate func zomatoButtonPressed() {
        guard let url = URL(string: restaurant?.url ?? "") else {
            return
        }
        let zomatoPageVC = SFSafariViewController(url: url)
        present(zomatoPageVC, animated: true)
    }
}
