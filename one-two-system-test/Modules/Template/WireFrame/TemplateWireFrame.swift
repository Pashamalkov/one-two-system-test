//
//  NewsListWireFrame.swift
// 

import Foundation
import UIKit

class TemplateWireFrame: TemplateWireFrameProtocol {
    var navigationRouter: NavigationRouterProtocol
    
    init(navigationRouter: NavigationRouterProtocol, requestManager: RequestManager) {
        self.navigationRouter = navigationRouter
    }
    
    func createTabbarModule() -> UIViewController {
        let viewController = TemplateViewController()
        let presenter: TemplatePresenterProtocol = TemplatePresenter()
        let wireFrame: TemplateWireFrameProtocol = self
        let interactor: TemplateInteractorProtocol = TemplateInteractor()
        
        presenter.wireFrame = wireFrame
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
}
