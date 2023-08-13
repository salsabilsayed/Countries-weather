//
//  CountryModel.swift
//  Countries-Weather
//
//  Created by ifts 25 on 08/04/23.
//

import Foundation

struct CountryModel: Codable{
    var name: Name
    var capital: [String]?
    var region: String
    var subregion: String?
    var flags: Flag
    var population: Int
    var maps: Map
    var latlng: [Double]
}

struct Name: Codable {
    var common: String?
}

struct Flag: Codable {
    var png: String
}

struct Map: Codable {
    var googleMaps: String
}


struct Country {
    
    static var fovouriteCountries: [CountryModel] = []
    
    static var archiveURL: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let url = documentURL.appendingPathComponent("notes").appendingPathExtension("plist")
        
        return url
    }
    
    static func saveToDevice(countries: [CountryModel]) {
        let encoder = PropertyListEncoder()
        let encodedCountries = try? encoder.encode(countries)
        try? encodedCountries?.write(to: Country.archiveURL)
    }
    
    static func loadFromDevice() -> [CountryModel]? {
        guard let countries = try? Data(contentsOf: Country.archiveURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        let decodedCountries = try? decoder.decode(Array<CountryModel>.self, from: countries)
        
        return decodedCountries
    }
}
