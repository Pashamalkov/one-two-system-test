//
//  InputDataViewModel.swift
//
//  Created by Павел on 23/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import UIKit

protocol InputDataViewModelProtocol {
    func getTitle() -> String
    var dataUpdateCallback: (()->())? { get set }
}

final class InputDataViewModel {
    private let router: NavigationRouterProtocol
    private let mainService: MainServiceProtocol
    private var fullProject: InputDataModelProtocol?
    var dataUpdateCallback: (()->())?
    
    init(router: NavigationRouterProtocol, mainService: MainServiceProtocol) {
        self.router = router
        self.mainService = mainService
        mainService.getFullData { [weak self] fullProject, error in
            guard let self = self else { return }
            if let fullProject = fullProject {
                self.fullProject = fullProject
                self.updateData()
            } else {
                print("ERROR: \(error)")
            }
        }
    }
    
    private func updateData() {
        dataUpdateCallback?()
    }
}

// MARK: - InputDataViewModelProtocol
extension InputDataViewModel: InputDataViewModelProtocol {
    func getTitle() -> String {
        return fullProject?.directory.name ?? "Test title"
    }
}
