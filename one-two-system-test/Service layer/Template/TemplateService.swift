//
//  PostService.swift
//  

import Foundation

protocol MainServiceProtocol: ServiceProtocol {
    
    //POST /get_project_ik
    func getFullData(_ completion: ((InputDataModel?, Error?) -> Void)?)
    
    //POST api/ik/silent_calculate/{project_dir_id}
    func calculate(parameters: [OutputData], _ completion: ((InputDataModel?, Error?) -> Void)?)
}

class MainService: MainServiceProtocol {
    var requestManager: RequestManager
    
    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }
    
    func getFullData(_ completion: ((InputDataModel?, Error?) -> Void)?) {
        
        requestManager.makePostRequest("get_project_ik", keyPath: nil, parameters: nil) { (result: CodableRequestResult<InputDataModel>) in
            switch result {
            case .success(let fullProject):
                completion?(fullProject, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
        
//        requestManager.makePostRequest("get_project_ik", parameters: nil) { json in
//            print("________")
//            print(json)
//            print("________")
//        }
        
//        requestManager.makePostRequest("get_project_ik", keyPath: nil, parameters: nil) { (CodableRequestResult<InputDataModel>) in
////            guard let strongSelf = self else { return }
//            switch result {
//            case .success(let certificate):
//                completion?(certificate, nil)
//            case .failure(let error):
//                completion?([], error)
//            }
//        }
    }
    
    func calculate(parameters: [OutputData], _ completion: ((InputDataModel?, Error?) -> Void)?) {
        requestManager.makePostRequest("api/ik/silent_calculate/124472", keyPath: nil, parameters: nil) { (result: CodableRequestResult<InputDataModel>) in
            switch result {
            case .success(let fullProject):
                completion?(fullProject, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}
