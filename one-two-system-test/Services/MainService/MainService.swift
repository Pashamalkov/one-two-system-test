//
//  PostService.swift
//  

import Foundation

protocol MainServiceProtocol: ServiceProtocol {
    
    //POST /get_project_ik
    func getFullData(_ completion: ((InputDataModel?, Error?) -> Void)?)
    
    //POST api/ik/silent_calculate/{project_dir_id}
    func calculate(parameters: [OutputData], _ completion: (([OutputData], Error?) -> Void)?)
}

class MainService: MainServiceProtocol {
    var requestManager: RequestManager
    var parser: MainParserProtocol
    
    init(requestManager: RequestManager, parser: MainParserProtocol) {
        self.requestManager = requestManager
        self.parser = parser
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
    
    func calculate(parameters: [OutputData], _ completion: (([OutputData], Error?) -> Void)?) {
        
        var json: String = ""
        for parameter in parameters {
            json += "\"\(parameter.inputId)\": { \"value_id\": \"-1\", \"value\": \"\(parameter.data?.value ?? "")\" }, "
        }
        json = String(json.dropLast())
        json = "{" + json + "}"
        
        let data = json.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: AnyObject]
            {
                requestManager.makePostRequest("ik/silent_calculate/124472", parameters: jsonArray) { [weak self] result in
                    guard let self = self
                        else { return }
                    
                    switch result {
                    case .success(let json):
                        print(json)
                        completion?(self.parser.parseOutputs(json), nil)
                    case .failure(let error):
                        completion?([], error)
                    }
                }
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    
////        let json:String =
//        "{\"id\": 24, \"name\": \"Bob Jefferson\", \"friends\": [{\"id\": 29, \"name\": \"Jen Jackson\"}]}"
//        "{
//        "6392": {
//            "value_id": "-1",
//            "value": "800"
//        },
//        "6393": {
//            "value_id": "-1",
//            "value": "500"
//        }
//    }"
        
        
        
        
//        requestManager.makePostRequest("api/ik/silent_calculate/124472", keyPath: nil, parameters: nil) { (result: CodableRequestResult<InputDataModel>) in
//            switch result {
//            case .success(let fullProject):
//                completion?(fullProject, nil)
//            case .failure(let error):
//                completion?(nil, error)
//            }
//        }
    }
}
