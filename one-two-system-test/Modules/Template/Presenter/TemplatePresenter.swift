//
//  NewsListPresenter.swift
//  

import Foundation
import UIKit

class TemplatePresenter: TemplatePresenterProtocol {

  weak var view: TemplateViewProtocol!
  var wireFrame: TemplateWireFrameProtocol!
  var interactor: TemplateInteractorProtocol!
    var router: NavigationRouterProtocol {
        return wireFrame.navigationRouter
    }
}
