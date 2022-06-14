//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Станислав Москальцов  on 14.06.2022.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let dt: Int
    
    struct Main: Codable {
        let temp: Double
        let pressure: Int
    }
    struct Weather: Codable {
        let id: Int
    }
}
