//
//  ServerResponse.swift
//  

import Foundation

struct ServerResponse<Value> {
    
    var value: Value? = nil
    var error: Error? = nil
    var statusCode: Int? = nil
    
    init() { }
    
    init(error: Error?, statusCode: Int? = nil) {
        self.error = error
        self.statusCode = statusCode
    }
    
    init(value: Value?, statusCode: Int? = nil) {
        self.value = value
        self.statusCode = statusCode
    }
    
    var result: Result<Value> {
        if let value = value {
            return Result.success(value)
        } else if let error = error {
            return Result.failure(error)
        } else {
            return Result.failure(ServerError.unspecifiedError)
        }
    }
}

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
