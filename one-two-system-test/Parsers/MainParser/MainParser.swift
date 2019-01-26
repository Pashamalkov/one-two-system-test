//
//  MainParser.swift
//  one-two-system-test
//
//  Created by Павел on 26/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MainParserProtocol {
    func parseOutputs(_ data: JSON) -> [OutputData]
}

class MainParser: MainParserProtocol {
    
    func parseOutputs(_ data: JSON) -> [OutputData] {
        var outputs: [OutputData] = []
        if let dataDictionary = data.dictionaryObject {
            for i in dataDictionary {
                var outputValue: OutputValue? = nil
                if let dictionary = data[i.key].dictionary, let valueID = dictionary["value_id"]?.int {
                    if let value = dictionary["value"]?.string {
                        outputValue = OutputValue(id: "\(valueID)", value: "\(value)")
                    } else if let value = dictionary["value"]?.int {
                        outputValue = OutputValue(id: "\(valueID)", value: "\(value)")
                    }
                    let output = OutputData.init(inputId: i.key, data: outputValue)
                    outputs.append(output)
                }
            }
        }
        return outputs
    }
    
}
