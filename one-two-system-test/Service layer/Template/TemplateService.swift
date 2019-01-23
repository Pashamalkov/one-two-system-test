//
//  PostService.swift
//  

import Foundation

protocol TemplateServiceProtocol: ServiceProtocol {
    func getTemplate(_ completion: (()->())?)
}

class TemplateService: TemplateServiceProtocol {
    var requestManager: RequestManager
    
    var templateParser = TemplateParser()
    
    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }
    
    func getTemplate(_ completion: (()->())?) {
        
        _ = requestManager.makeGetRequest("", parameters: nil, completedBlock: { [weak self] in
            guard let strongSelf = self else { return }
            switch $0 {
            case .success(let json):
//                completion?(strongSelf.templateParser.parseTemplate( json["data"]), nil)
                break
            case .failure(let error):
//                completion?([], error)
                break
            }
        })
    }
}
