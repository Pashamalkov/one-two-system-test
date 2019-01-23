//
//  NewsListProtocols.swift
//  

import Foundation

protocol TemplateWireFrameProtocol : class {
    var navigationRouter: NavigationRouterProtocol { get }
}

protocol TemplateViewProtocol : class {
    
  var presenter: TemplatePresenterProtocol! { get set }
  func updateData()
}

protocol TemplatePresenterProtocol : class {
  weak var view: TemplateViewProtocol! { get set }
  var interactor: TemplateInteractorProtocol! { get set }
  var wireFrame: TemplateWireFrameProtocol! { get set }
    var router: NavigationRouterProtocol { get }
}

protocol TemplateInteractorProtocol : class {
  weak var presenter: TemplatePresenterProtocol! { get set }
}
