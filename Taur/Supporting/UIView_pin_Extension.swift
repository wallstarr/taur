//
//  UIView_pin_Extension.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
    
}
