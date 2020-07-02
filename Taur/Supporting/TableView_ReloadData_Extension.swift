//
//  TableView_ReloadData_Extension.swift
//  Taur
//
//  Created by DAN BLUSTEIN on 2020/07/02.
//  Copyright © 2020 Dan Blustein. All rights reserved.
//

import UIKit

extension UITableView {
  func animateCells<Cell: UITableViewCell>(cells: [Cell],
                                           duration: TimeInterval,
                                           delay: TimeInterval = 0,
                                           dampingRatio: CGFloat = 0,
                                           configure: @escaping (Cell) -> (prepare: () -> Void, animate: () -> Void)?) {
    var cellDelay: TimeInterval = 0
    var completionCount: Int = 0

    for cell in cells {
      if let callbacks = configure(cell) {
        callbacks.prepare()

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio)

        animator.addAnimations(callbacks.animate)

        animator.startAnimation(afterDelay: cellDelay)

        cellDelay += delay
      } else {
        completionCount += 1
      }
    }
  }
}
