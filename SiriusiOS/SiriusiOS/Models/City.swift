//
// City
// SiriusiOS
//
// Created by Methas Tariya on 31/5/23.
//

import Foundation

struct City: Codable {
    let name: String
    let country: String
    let coord: Coord

    struct Coord: Codable {
        let lat: Double
        let lng: Double

        enum CodingKeys: String, CodingKey {
            case lat
            case lng = "lon"
        }
    }

}