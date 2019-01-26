//
//  InputDataViewModel.swift
//
//  Created by Павел on 23/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import UIKit

protocol InputDataViewModelProtocol {
    func getTitle() -> String
    func setData(id: Int, text: String)
    func uploadData()
    var dataUpdateCallback: (()->())? { get set }
    var rows: [Put] { get }
    var newData: [OutputData] { get }
}

final class InputDataViewModel {
    private let router: NavigationRouterProtocol
    private let mainService: MainServiceProtocol
    private var fullProject: InputDataModelProtocol?
    var dataUpdateCallback: (()->())?
    
    var rows: [Put] = []
    var newData: [OutputData] = []
    
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
        rows = fullProject?.ik.inputs.filter({ $0.directory.name.lowercased() == "ширина" || $0.directory.name.lowercased() == "высота" }) ?? []
        newData = []
        for row in rows {
            let outputValue = OutputValue.init(id: "\(-1)", value: row.value)
            newData.append(OutputData(inputId: "\(row.id)", data: outputValue))
        }
        dataUpdateCallback?()
    }
    
    func setData(id: Int, text: String) {
        if var index = newData.firstIndex(where: { $0.inputId == "\(id)" }) {
            let outputValue = OutputValue.init(id: "\(-1)", value: text)
            newData[index].data = outputValue
        }
    }
    
    func uploadData() {
        mainService.calculate(parameters: newData) { (input, error) in
            
        }
    }
}

// MARK: - InputDataViewModelProtocol
extension InputDataViewModel: InputDataViewModelProtocol {
    func getTitle() -> String {
        return fullProject?.directory.name ?? "Test title"
    }
}
