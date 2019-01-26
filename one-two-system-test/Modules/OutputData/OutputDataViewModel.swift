//
//  OutputDataViewModel.swift
//
//  Created by Павел on 26/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import UIKit

protocol OutputDataViewModelProtocol {
    func getTitle() -> String
    var dataUpdateCallback: (()->())? { get set }
    var rows: [(Put,String)] { get }
}

final class OutputDataViewModel {
    private let router: NavigationRouterProtocol
    var dataUpdateCallback: (()->())?
    var rows: [(Put,String)] = []
    
    init(router: NavigationRouterProtocol, data: [(Put,String)]) {
        self.router = router
        self.rows = data
    }
    
    private func updateData() {
        dataUpdateCallback?()
    }
}

// MARK: - InputDataViewModelProtocol
extension OutputDataViewModel: OutputDataViewModelProtocol {
    func getTitle() -> String {
        return "Итог"
    }
}
