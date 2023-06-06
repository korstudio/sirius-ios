//
// City
// SiriusiOS
//
// Created by Methas Tariya on 31/5/23.
//

import Foundation

struct City: Codable, Equatable, Comparable {
    let name: String
    let country: String
    let coord: Coord
    var title: String {
        "\(name), \(country)"
    }

    struct Coord: Codable {
        let lat: Double
        let lng: Double
        var text: String {
            "(\(lat), \(lng))"
        }

        enum CodingKeys: String, CodingKey {
            case lat
            case lng = "lon"
        }
    }

    static func ==(lhs: City, rhs: City) -> Bool {
        lhs.title == rhs.title
    }

    static func >(lhs: City, rhs: City) -> Bool {
        lhs.name > rhs.name && lhs.country > rhs.country
    }

    static func <(lhs: City, rhs: City) -> Bool {
        lhs.name < rhs.name && lhs.country < rhs.country
    }
}
