//
//  UIViewControllerExtension.swift
//  SpotiFav
//
//  Created by Cao Mai on 10/5/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func emptyMessage(message: String, duration: Double) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        label.transform = CGAffineTransform(scaleX: 0, y: 0)
        label.text = message
        
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        label.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: nil)
    }
}
