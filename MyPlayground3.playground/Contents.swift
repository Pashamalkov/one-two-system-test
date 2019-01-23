import UIKit

struct Welcome: Codable {
    let id: Int
    let name, surname, middlename: String
    let photo: String
    let rating, description: String
    let specialization: Specialization
    let academicDegree, education, category, title: String
    let experience: String
    let clinics: [Clinic]
}

struct Clinic: Codable {
    let id: Int
    let name, address, phones, latitude: String
    let longitude: String
    let metro: Metro
    let schedule: [Schedule]
}

struct Metro: Codable {
    let id: Int
    let name, color: String
}

struct Schedule: Codable {
    let clinicID, day: Int
    let timeFrom, timeTo: String
    
    enum CodingKeys: String, CodingKey {
        case clinicID = "clinic_id"
        case day
        case timeFrom = "time_from"
        case timeTo = "time_to"
    }
}

struct Specialization: Codable {
    let id: Int
    let name: String
}
