//
//  ViewControllerFactory.swift
//  

import Foundation


import Foundation
import UIKit

enum ViewControllerType {
    case inputData
    case outputData(_ data: [(Put,String)])
}

class ViewControllerFactory {
    func configureViewControllerWithType(_ type: ViewControllerType, navigationRouter: NavigationRouterProtocol) -> UIViewController {
        let requestManager = createRequestManager()
        let mainService = MainService(requestManager: requestManager, parser: MainParser())
        switch type {
        case .inputData:
            return InputDataViewController(viewModel: InputDataViewModel(router: navigationRouter, mainService: mainService))
        case .outputData(let data):
            return OutputDataViewController(viewModel: OutputDataViewModel(router: navigationRouter, data: data))
        }
    }
    
    private func createRequestManager() -> RequestManager {
        let requestManager = RequestManager(host: "http://81.195.151.70:8000/api/")
        return requestManager
    }
}
