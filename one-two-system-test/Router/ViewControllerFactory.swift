//
//  ViewControllerFactory.swift
//  

import Foundation


import Foundation
import UIKit

enum ViewControllerType {
    case inputData
}

class ViewControllerFactory {
    func configureViewControllerWithType(_ type: ViewControllerType, navigationRouter: NavigationRouterProtocol) -> UIViewController {
        let requestManager = createRequestManager()
        let mainService = MainService(requestManager: requestManager)
        switch type {
        case .inputData:
            return InputDataViewController.init(viewModel: InputDataViewModel.init(router: navigationRouter, mainService: mainService))
        }
    }
    
    private func createRequestManager() -> RequestManager {
        let requestManager = RequestManager(host: "http://81.195.151.70:8000/api/")
        return requestManager
    }
}
