//
//  PostParser.swift
//  

import Foundation
import SwiftyJSON

protocol TemplateParserProtocol {
    func parseTemplate(_ data: JSON) -> [Template]
}

class TemplateParser: TemplateParserProtocol {
    func parseTemplate(_ data: JSON) -> [Template] {
        var array: [Template] = []
        for (_, subJson): (String, JSON) in data {
            if let item = try? parseOneTemplate(subJson) {
                array += [item]
            }
        }
        return array
    }
    
    func parseOneTemplate(_ data: JSON) throws -> Template {
        guard let id = data["id"].string else { throw CommonError.wrongJSON }
        var template = Template(id: id)
        if let text = data["text"].string {
            template.text = text
        }
        return template
    }
}
