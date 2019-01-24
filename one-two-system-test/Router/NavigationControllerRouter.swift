//
//  NavigationControllerRouter.swift
//  

import Foundation
import UIKit

protocol NavigationRouterProtocol: class {
    
    var navigationController: UINavigationController { get }
    
    func performTransitionToController(with viewControllerType: ViewControllerType)
    func performBackTransition()
}

class NavigationControllerRouter: NavigationRouterProtocol {
    
    
    var navigationController: UINavigationController = UINavigationController()
    private(set) var viewControllerFactory: ViewControllerFactory
    
    required init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
        navigationController = UINavigationController(rootViewController: viewControllerFactory.configureViewControllerWithType(.inputData, navigationRouter: self))
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = UIColor.clear
    }
    
    
    
    func performTransitionToController(with viewControllerType: ViewControllerType) {
        
        let vc = viewControllerFactory.configureViewControllerWithType(viewControllerType, navigationRouter: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func performBackTransition() {
        navigationController.popViewController(animated: true)
    }
}

