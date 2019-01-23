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
    func makePostPhotoRequest(_ path: String, nameImageParameter: String, data: Data?, format: String, parameters: [String:AnyObject]?, completedBlock: @escaping ((Bool,JSON?) -> Void))
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
    
    private lazy var versionParameters: [String: Any] = {
        let parameters: [String: Any] = [:
//            "version": SystemConstants.methods.appVersion(),
//            "os": "ios",
//            "type": "client",
//            "device": SDiOSVersion.deviceNameString(),
//            "osVersion": UIDevice.current.systemVersion,
            ]
        return parameters
    }()
    
    let arrayUrlsNotNeedToken = ["auth","/registration"]
    
    // MARK: - Initialization
    public required init(host: String) {
        self.host = host
    }
}

//// MARK: - RequestManagerCodable
//extension RequestManager: RequestManagerCodable {
//    func makeGetRequest<Result>(_ path: String, keyPath: String?, parameters: [String: Any]?,
//                                completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
//        return makeRequest(.get, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
//    }
//
//    func makePostRequest<Result>(_ path: String, keyPath: String?, parameters: [String: Any]?,
//                                 completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
//        return makeRequest(.post, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
//    }
//
//    func makeDeleteRequest<Result>(_ path: String, keyPath: String?, parameters: [String: Any]?,
//                                   completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
//        return makeRequest(.delete, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
//    }
//
//    @discardableResult
//    func makeRequest<Result>(_ method: HTTPMethod, path: String, keyPath: String?,
//                             parameters: [String: Any]?,
//                             completion: ((CodableRequestResult<Result>) -> ())?) -> Alamofire.Request? {
//
//        var httpHeaders = applicationHeaders()
//        httpHeaders["Content-Type"] = "application/json"
//        let encoding: ParameterEncoding
//        switch method {
//        case .get:
//            encoding = URLEncoding.default
//        default:
//            encoding = JSONEncoding.default
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .secondsSince1970
//
//
//        return Alamofire.request("\(host)\(path)", method: method, parameters: getConfiguredRequestParameters(parameters), encoding: encoding, headers: httpHeaders).responseDecodableObject(keyPath: keyPath, decoder: decoder) { (response: DataResponse<ServerResponse<Result>>) in
//            self.networkActivityIndicatorManager.removeActivity()
//
//            if let value = response.result.value {
//                if value.success {
//                    if let data = value.data {
//                        completion?(CodableRequestResult.success(data))
//                    } else {
//                        completion?(CodableRequestResult.failure(CommonError.wrongJSON))
//                    }
//                } else {
//                    DDLogWarn("Request return an error for path: \(self.host)\(path)")
//                    let error = value.error ?? ServerError.unknownError
//                    self.retryRequestAfterHandleIncludedError(error, retryBlock: {
//                        self.makeRequest(method, path: path, keyPath: keyPath, parameters: parameters, completion: completion)
//                    }, failureBlock: { error in
//                        completion?(CodableRequestResult.failure(error))
//                    })
//                }
//            } else {
//                completion?(CodableRequestResult.failure(response.result.error!))
//            }
//        }
//    }

//}

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
    
    func makePostPhotoRequest(_ path: String, nameImageParameter: String, data: Data?, format: String, parameters: [String:AnyObject]?, completedBlock: @escaping ((Bool,JSON?) -> Void)) {
        makeRequestSendImage(.post , nameImageParameter: nameImageParameter, data: data, format: format, path: path, parameters: parameters, completedBlock: completedBlock)
    }
    
    fileprivate func makeRequestSendImage(_ method: HTTPMethod, nameImageParameter: String, data: Data?, format: String, path: String, parameters: [String:AnyObject]?, completedBlock: @escaping ((Bool,JSON?) -> Void)) {
        
        let URL = "\(host)\(path)"
        
        var httpHeaders = applicationHeaders()
        httpHeaders["Content-Type"] = "multipart/form-data"
        
        if let unwrapData = data {
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                switch format {
                case "png":
                    multipartFormData.append(unwrapData, withName: nameImageParameter, fileName: "\(nameImageParameter).\(format)", mimeType: "image/png")
                case "pdf","xls","xlsm","xlsx","docx","doc":
                    multipartFormData.append(unwrapData, withName: "image", fileName: "\(nameImageParameter).\(format)", mimeType: "multipart/form-data")
                default:
                    break
                }
                
                for (key, value) in self.getConfiguredRequestParameters(parameters) {
                    if value is String || value is Int || value is Int64 {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
               to: URL,
               method: method,
               headers: httpHeaders,
               encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let jsonDictionary = response.result.value {
                            let json = JSON(jsonDictionary)
                            if json["success"].boolValue == false {
                                completedBlock(false, nil)
                            } else {
                                completedBlock(true, json)
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
            
        } else {
            completedBlock(false, nil)
        }
    }
    
    func makeRequest(_ method: HTTPMethod, path: String, parameters: [String:AnyObject]?, completedBlock: @escaping RequestManagerCompletedBlock) -> Alamofire.Request? {
        
        var httpHeaders = applicationHeaders()
        httpHeaders["Content-Type"] = "application/json"
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
                if json["status"].string == "ok" {
                     completedBlock(FetchRequestResult.success(json["result"]))
                } else {
                    completedBlock(FetchRequestResult.failure(response.result.error!))
                }
            } else {
                completedBlock(FetchRequestResult.failure(response.result.error!))
            }
        }
    }
    
    func getConfiguredRequestParameters(_ parameters: [String: Any]?) -> [String: Any] {
        var finalParameters: [String: Any] = parameters ?? [:]
//        finalParameters["application"] = versionParameters // set application version parameters
//        if let userToken = loginManager?.loginStorage.token {
//            finalParameters["token"] = userToken // set user token
//        }
        return finalParameters
    }
    
}
