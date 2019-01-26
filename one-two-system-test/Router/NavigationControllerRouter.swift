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
        UINavigationBar.appearance().backgroundColor = UIColor.white
        if let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
            statusBarView.backgroundColor = UIColor.white
        }
    }
    
    func performTransitionToController(with viewControllerType: ViewControllerType) {
        
        let vc = viewControllerFactory.configureViewControllerWithType(viewControllerType, navigationRouter: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func performBackTransition() {
        navigationController.popViewController(animated: true)
    }
}

