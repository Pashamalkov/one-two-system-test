//
//  NavigationItemConfigurationProtocol.swift
//  Overtime
//
//  Created by Павел on 19.03.18.
//  Copyright © 2018 Mikhail Arzumanov. All rights reserved.
//

import Foundation
import UIKit

//enum NavigationItemTitleItemType {
//    case mainScreen
//    case wsual
//
//    func configureTitleItem(_ navigationItem: UINavigationItem) {
//        switch self {
//        case .logoWhite:
//            navigationItem.titleView = UIImageView(image: UIImage(named: "navigation-bar-title-white-logo"))
//        case .logoRed:
//            let imageView = UIImageView(image: UIImage(named: "Logo_load"))
//            imageView.frame = CGRect(x: 0, y: 0, width: 64, height: 24)
//            imageView.contentMode = .scaleAspectFit
//            imageView.tintColor = UIColor.doc_redSecondaryColor()
//            navigationItem.titleView = imageView
//        }
//    }
//}

enum NavigationItemTitleTextItemType {
    case grayStyle
    case whiteStyle
    case redStyle
    
    var textColor: UIColor {
        switch self {
        case .grayStyle:    return .black
        case .whiteStyle:   return .white
        case .redStyle:     return .red
        }
    }
    
    func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "BebasTam", size: 23)!,  NSAttributedStringKey.kern : 5.0]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        label.sizeToFit()
        return label
    }
}

protocol NavigationItemConfigurationProtocol {
    
    func configureRightButtonWithImage(_ navigationItem: UINavigationItem, imageName:String) -> UIButton
    
    func configureDoneChangeProfileButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureChangeProfileButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureBackButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureCloseButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureCallButtonButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureAssayCount(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureTitleView(_ navigationItem: UINavigationItem)
    
    func configureHiddenBackButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureHiddenrightButton(_ navigationItem: UINavigationItem) -> UIButton
    
    func configureTitleText(_ text: String, onNavigationItem item: UINavigationItem, withStyle style: NavigationItemTitleTextItemType)
    func configure(_ navigationItem: UINavigationItem, text: String, style: NavigationItemTitleTextItemType, subtitleView: UIView)
    
    func configureRightButtonWithImageCustomInset(_ frame :CGRect,
                                                  imageEdgeInsets:UIEdgeInsets, navigationItem: UINavigationItem,imageName:String) -> UIButton
}

extension NavigationItemConfigurationProtocol {
    func configureBackButton(_ navigationItem: UINavigationItem) -> UIButton {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "navigation-bar-back-button-icon"), for: UIControlState())
        backButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -10, 0, 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        return backButton
    }
    
    func configureHiddenBackButton(_ navigationItem: UINavigationItem) -> UIButton {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "ava_alpha"), for: UIControlState())
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        return backButton
    }
    
    func configureHiddenrightButton(_ navigationItem: UINavigationItem) -> UIButton {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "ava_alpha"), for: UIControlState())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        return backButton
    }
    
    func configureCloseButton(_ navigationItem: UINavigationItem) -> UIButton {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "navigation-bar-close-button-icon"), for: UIControlState())
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        return backButton
    }
    
    func configureTitleView(_ navigationItem: UINavigationItem) {
//        type.configureTitleItem(navigationItem)
    }
    
    func configureTitleText(_ text: String, onNavigationItem item: UINavigationItem,  withStyle style: NavigationItemTitleTextItemType) {
        item.titleView = style.createLabel(with: text)
    }
    
    func configure(_ navigationItem: UINavigationItem, text: String,  style: NavigationItemTitleTextItemType, subtitleView: UIView) {
        let contentView = UIView()
        let titleView = UIView()
        titleView.addSubview(contentView)
        
        let titleLabel = style.createLabel(with: text)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        subtitleView.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(-4)
            make.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        navigationItem.titleView = titleView
    }
    
    func configureDoneChangeProfileButton(_ navigationItem: UINavigationItem) -> UIButton {
        let backButton = UIButton()
        backButton.frame = CGRect(x: 0, y: 0, width: 55, height: 40)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0)
        backButton.setTitleColor(UIColor.black, for: UIControlState())
        backButton.setTitle("Готово", for: UIControlState())
//        backButton.titleLabel!.font =  UIFont().
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        
        return backButton
    }
    
    func configureRightButtonWithImageCustomInset(_ frame :CGRect,
                                                  imageEdgeInsets:UIEdgeInsets, navigationItem: UINavigationItem,imageName:String) -> UIButton {
        let backButton = UIButton()
        backButton.frame = frame
        backButton.imageEdgeInsets = imageEdgeInsets
        backButton.setImage(UIImage(named: imageName), for: UIControlState())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        
        return backButton
    }
    
    func configureRightButtonWithImage(_ navigationItem: UINavigationItem,imageName:String) -> UIButton {
        return configureRightButtonWithImageCustomInset(CGRect(x: 0, y: 0, width: 44, height: 44),
                                                        imageEdgeInsets: UIEdgeInsetsMake(-2, 20, 0, 0),
                                                        navigationItem: navigationItem, imageName: imageName)
    }
    
    func configureAssayCount(_ navigationItem: UINavigationItem) -> UIButton {
        
        let btnBasket = UIButton()
        btnBasket.backgroundColor = .clear
        btnBasket.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
//        btnBasket.titleLabel?.font = UIFont().setDocFont_BoldWithSize(16)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnBasket
        navigationItem.rightBarButtonItem = rightBarButton
        
        return btnBasket
    }
    
    func configureCallButtonButton(_ navigationItem: UINavigationItem) -> UIButton {
        return configureRightButtonWithImage(navigationItem, imageName: "callNav")
    }
    
    func configureChangeProfileButton(_ navigationItem: UINavigationItem) -> UIButton {
        return configureRightButtonWithImage(navigationItem, imageName: "ico_edit")
    }
}
