//
//  NavigationItemConfiguration.swift
//  

import Foundation
import UIKit

protocol NavigationItemConfigurationProtocol {
    func configureTitle(_ text: String, onNavigationItem item: UINavigationItem, attributes: [NSAttributedStringKey : Any])
    func configureRightButton(_ navigationItem: UINavigationItem, imageName:String) -> UIButton
    func configureLeftButton(_ navigationItem: UINavigationItem, imageName:String) -> UIButton
}

extension NavigationItemConfigurationProtocol {
    
    func configureTitle(_ text: String, onNavigationItem item: UINavigationItem, attributes: [NSAttributedStringKey : Any]) {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        label.sizeToFit()
        item.titleView = label
    }
    
    func configureRightButton(_ navigationItem: UINavigationItem, imageName: String) -> UIButton {
        let button = configureButton(imageName: imageName, frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    func configureLeftButton(_ navigationItem: UINavigationItem, imageName: String) -> UIButton {
        let button = configureButton(imageName: imageName, frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    func configureProfileButton(_ navigationItem: UINavigationItem, imageName: String) -> UIButton {
        let button = configureButton(imageName: imageName, frame: CGRect.init(x: 0, y: 0, width: 45, height: 50))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.titleView?.bringSubview(toFront: button)
        return button
    }
    
    private func configureButton(imageName: String, frame: CGRect) -> UIButton {
        let button = UIButton()
        button.frame = frame
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 5)
        if let image = UIImage(named: imageName) {
            button.setImage(UIImage(), for: .normal)
        }
        return button
    }
}
