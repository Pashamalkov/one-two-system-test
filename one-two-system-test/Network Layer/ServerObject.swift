//
//  ServerObject.swift
//  

import Foundation
import SwiftyJSON

protocol ServerObject {
    associatedtype ObjectType = Self
    static func createWith(_ json: JSON) -> ObjectType?
    var dict: [String: Any]? { get }
}

extension ServerObject {
    var dict: [String: Any]? { return nil }
}
