//
//  ServerError.swift
//  

import Foundation

enum ServerError: Error {
    case unauthorized
    case internalServerError
    case invalidData
    case notConnectedToInternet
    case networkConnectionLost
    case cancelled
    case timedOut
    case notFound
    case noData
    case forbidden
    case unspecifiedError
    case errorWithMessage(message: String, statusCode: Int)
    case unspecified(statusCode: Int)
    
    init(error: Error?) {
        if let serverError = error as? ServerError { self = serverError; return }
        guard let error = error as? URLError else { self = .unspecifiedError; return }
        
        switch error {
        case URLError.notConnectedToInternet:
            self = .notConnectedToInternet
        case URLError.networkConnectionLost:
            self = .networkConnectionLost
        case URLError.cancelled:
            self = .cancelled
        case URLError.timedOut:
            self = .timedOut
        default:
            self = .unspecifiedError
        }
    }
    
    init(statusCode: Int) {
        switch statusCode {
        case 401:
            self = .unauthorized
        case 404:
            self = .notFound
        case 403:
            self = .forbidden
        case 408:
            self = .timedOut
        case 500...599:
            self = .internalServerError
        default:
            self = .unspecified(statusCode: statusCode)
        }
    }
    
    func errorMessage() -> String {
        switch self {
        case .timedOut:
            return "Time out"
        case .unauthorized:
            return "Ошибка авторизации"
        case .internalServerError:
            return "Внутренняя ошибка сервера"
        case .invalidData:
            return "Неверный формат данных с сервера"
        case .notConnectedToInternet:
            return "Нет подключения к сети"
        case .networkConnectionLost:
            return "Потеряно подключение к сети"
        case .notFound:
            return "Сервер не найден."
        case .forbidden:
            return "Доступ запрещен"
        case .cancelled:
            return "Запрос был прерван"
        case .unspecifiedError:
            return "Неизвестная ошибка"
        case .unspecified(let statusCode):
            return "Неизвестная ошибка с кодом \(statusCode)"
        case .noData:
            return "Данные не были получены"
        case let .errorWithMessage(message, statusCode):
            return "\(message)\nКод ошибки: \(statusCode)"
        }
    }
}
