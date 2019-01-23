//
//  ViewControllerFactory.swift
//  

import Foundation


import Foundation
import UIKit

enum ViewControllerType {
    case templateListViewController
}

class ViewControllerFactory {
    func configureViewControllerWithType(_ type: ViewControllerType, navigationRouter: NavigationRouterProtocol) -> UIViewController {
        let requestManager = createRequestManager()
        switch type {
        case .templateListViewController:
            return TemplateWireFrame(navigationRouter: navigationRouter, requestManager: requestManager).createTabbarModule()
        }
    }
    
    private func createRequestManager() -> RequestManager {
        let requestManager = RequestManager(host: "http://template.ru/api/")
        return requestManager
    }
}
