//
//  CommonError.swift
//  

import Foundation

enum CommonError: Error {
    case wrongJSON
}

extension CommonError: LocalizedError {
    func descriptionMessageForError() -> String {
        return errorDescription ?? ""
    }
    
    public var errorDescription: String? {
        switch self {
        case .wrongJSON:
            return "Неверный формат JSON"
        }
    }
}
