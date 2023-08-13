//
//  WeatherModell.swift
//  Countries-Weather
//
//  Created by ifts 25 on 11/04/23.
//

import Foundation

struct WeatherResponse: Codable {
    var weather: [Weather]
    var main: Main
    var sys: Sys
    var name: String
}

struct Weather: Codable {
    var id: Int
    var description: String
    
    var conditionName: String {
        switch id {
        case 200...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"

        case 600...622: return "cloud.now"
        case 701...781: return  "cloud.fog"
        case 800: return "sun.max"
        case 801...804: return "cloud.bolt"
        default : return "cloud"
        }
    }
}

struct Main: Codable {
    var temp_min: Double
    var temp_max: Double
    var humidity: Int
    
    var tempratureString: String {
        return String(format: "%.1f", temp_max)
    }
    
}

struct Sys: Codable {
    let sunrise, sunset: Int
}
