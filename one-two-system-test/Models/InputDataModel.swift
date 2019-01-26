//
//  InputDataModel.swift
//
//  Created by Павел on 23/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import Foundation

protocol InputDataModelProtocol {
    var ik: Ik { get }
    var directory: Directory { get } 
}

struct InputDataModel: Codable, InputDataModelProtocol {
    let price: String
    let original: Int
    let createdAt: String
    let camAz: Double
    let calculatedAt: String
    let camAy: Double
    let ik: Ik
    let arMode: Int
    let camAx, camY: Double
    let description: String
    let order: Int
    let camZoom: Double
    let thumbnail: String
    let id: Int
    let camZ: Double
    let directory: Directory
    let productionDate: Int
    let camX: Double
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case price, original
        case createdAt = "created_at"
        case camAz = "cam_az"
        case calculatedAt = "calculated_at"
        case camAy = "cam_ay"
        case ik
        case arMode = "ar_mode"
        case camAx = "cam_ax"
        case camY = "cam_y"
        case description, order
        case camZoom = "cam_zoom"
        case thumbnail, id
        case camZ = "cam_z"
        case directory
        case productionDate = "production_date"
        case camX = "cam_x"
        case updatedAt = "updated_at"
    }
}

struct Directory: Codable {
    let group: Int
    let name: String
    let localParent, id, type, localID: Int
    let parent: Int
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case group, name
        case localParent = "local_parent"
        case id, type
        case localID = "local_id"
        case parent, icon
    }
}

struct Ik: Codable {
    let localIkData, inputOrderCol, sheet, inputIDCol: String
    let outputStartRow: Int
    let inputNameCol, inputValueCol: String
    let inputs: [Put]
    let outputOrderCol: String
    let inputStartRow: Int
    let useLocal: Bool
    let outputNameCol: String
    let outputs: [Put]
    let path, outputValueCol, outputIDCol: String
    let id: Int
    let directory: Directory
    let workbook: String
    
    enum CodingKeys: String, CodingKey {
        case localIkData = "local_ik_data"
        case inputOrderCol = "input_order_col"
        case sheet
        case inputIDCol = "input_id_col"
        case outputStartRow = "output_start_row"
        case inputNameCol = "input_name_col"
        case inputValueCol = "input_value_col"
        case inputs
        case outputOrderCol = "output_order_col"
        case inputStartRow = "input_start_row"
        case useLocal = "use_local"
        case outputNameCol = "output_name_col"
        case outputs, path
        case outputValueCol = "output_value_col"
        case outputIDCol = "output_id_col"
        case id, directory, workbook
    }
}

struct Put: Codable {
    let valueID: String
    let dirID: Int
    let isUsed: Bool
    let orderCell, idCell: String
    let order: Int
    let valueCell, nameCell: String
    let paramName: ParamName
    let value: String
    let id: Int
    let directory: Directory
    let type: String
    let content: [Directory]?
    
    enum CodingKeys: String, CodingKey {
        case valueID = "value_id"
        case dirID = "dir_id"
        case isUsed = "is_used"
        case orderCell = "order_cell"
        case idCell = "id_cell"
        case order
        case valueCell = "value_cell"
        case nameCell = "name_cell"
        case paramName = "param_name"
        case value, id, directory, type, content
    }
}

enum ParamName: String, Codable {
    case empty = ""
    case height = "height"
    case material = "material"
    case perforation = "perforation"
    case width = "width"
}
