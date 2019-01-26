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
        
        _ = requestManager.makePostRequest("get_project_ik", keyPath: nil, parameters: nil) { (result: CodableRequestResult<InputDataModel>) in
            switch result {
            case .success(let fullProject):
                completion?(fullProject, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
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
                _ = requestManager.makePostRequest("ik/silent_calculate/124472", parameters: jsonArray) { [weak self] result in
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
    }
}
