//
//  RequestManager.swift
//  

import Foundation
import Alamofire
import CodableAlamofire
import SwiftyJSON
//import CocoaLumberjack
//import SDVersion

let ClientURLPrefix = ""

protocol NetworkManagerProtocol {
    init(host: String)
    func makeGetRequest(_ path: String, parameters: [String:AnyObject]?, completedBlock:@escaping RequestManagerCompletedBlock) -> Alamofire.Request?
    func makeDeleteRequest(_ path: String, parameters: [String:AnyObject]?, completedBlock:@escaping RequestManagerCompletedBlock) -> Alamofire.Request?
    func makePostRequest(_ path: String, parameters: [String:AnyObject]?, completedBlock:@escaping RequestManagerCompletedBlock) -> Alamofire.Request?
}


protocol RequestManagerCodable: NetworkManagerProtocol {
    @discardableResult
    func makeGetRequest<Result: Decodable>(_ path: String, keyPath: String?, parameters: [String: Any]?,
                                           completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request?
    @discardableResult
    func makePostRequest<Result: Decodable>(_ path: String, keyPath: String?, parameters: [String: Any]?,
                                            completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request?
    @discardableResult
    func makeDeleteRequest<Result: Decodable>(_ path: String, keyPath: String?, parameters: [String: Any]?,
                                              completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request?
}

typealias RequestManagerCompletedBlock = ((FetchRequestResult<JSON>) -> Void)

enum CodableRequestResult<Data: Decodable> {
    case success(Data)
    case failure(Error)
}

enum FetchRequestResult<T> {
    case success(T)
    case failure(Error)
}

class RequestManager {
    private let host: String
    
    let arrayUrlsNotNeedToken = ["auth","/registration"]
    
    // MARK: - Initialization
    public required init(host: String) {
        self.host = host
    }
    
    let almgr : Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "81.195.151.70:8000": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()
}


extension RequestManager: RequestManagerCodable {
    func makeGetRequest<Result>(_ path: String, keyPath: String?, parameters: [String: Any]?,
                                completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
        return makeRequest(.get, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
    }
    
    func makePostRequest<Result>(_ path: String, keyPath: String?, parameters: [String: Any]?,
                                 completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
        return makeRequest(.post, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
    }
    
    func makeDeleteRequest<Result>(_ path: String, keyPath: String?, parameters: [String: Any]?,
                                   completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
        return makeRequest(.delete, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
    }
    
    @discardableResult
    func makeRequest<Result>(_ method: HTTPMethod, path: String, keyPath: String?,
                             parameters: [String: Any]?,
                             completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
        
        var httpHeaders = applicationHeaders()
        httpHeaders["Content-Type"] = "application/json"
        let encoding: ParameterEncoding
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let requestPath = "\(host)\(path)"
        let request = almgr.request(
            requestPath,
            method: method,
            parameters: getConfiguredRequestParameters(parameters),
            encoding: encoding,
            headers: httpHeaders)
        
        return request.responseDecodableObject(keyPath: keyPath, decoder: decoder) { (response: DataResponse<Result>) in
            
            switch response.result {
            case let .success(value):
                completion?(CodableRequestResult.success(value))
            case let .failure(error):
                completion?(CodableRequestResult.failure(error))
            }
        }
    }
}

// MARK: - RequestManagerProtocol
extension RequestManager {
    
    fileprivate func applicationHeaders() -> HTTPHeaders {
        var params = HTTPHeaders()
        return params
    }
    func makeDeleteRequest(_ path: String, parameters: [String:AnyObject]?, completedBlock: @escaping RequestManagerCompletedBlock) -> Alamofire.Request? {
        return makeRequest(.delete, path: path, parameters: parameters, completedBlock: completedBlock)
    }
    
    func makeGetRequest(_ path: String, parameters: [String:AnyObject]?, completedBlock: @escaping RequestManagerCompletedBlock) -> Alamofire.Request? {
        return makeRequest(.get, path: path, parameters: parameters, completedBlock: completedBlock)
    }
    
    func makePostRequest(_ path: String, parameters: [String:AnyObject]?, completedBlock: @escaping RequestManagerCompletedBlock) -> Alamofire.Request? {
        return makeRequest(.post, path: path, parameters: parameters, completedBlock: completedBlock)
    }
    
    func makeRequest(_ method: HTTPMethod, path: String, parameters: [String:AnyObject]?, completedBlock: @escaping RequestManagerCompletedBlock) -> Alamofire.Request? {
        
        var httpHeaders = applicationHeaders()
        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["XAUTHSUBJECT"] = "80614a86-4b9f-4df7-9e91-7500e2a239ed"
        var encoding: ParameterEncoding
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        
        
        return Alamofire.request("\(host)\(path)", method: method, parameters: getConfiguredRequestParameters(parameters), encoding: encoding, headers: httpHeaders).responseJSON {
            response in
            if let jsonDictionary = response.result.value {
                let json = JSON(jsonDictionary)
                completedBlock(FetchRequestResult.success(json))
            } else {
                completedBlock(FetchRequestResult.failure(response.result.error!))
            }
        }
    }
    
    func getConfiguredRequestParameters(_ parameters: [String: Any]?) -> [String: Any] {
        var finalParameters: [String: Any] = parameters ?? [:]
        finalParameters["dir_id"] = "124472"
        return finalParameters
    }
    
}
