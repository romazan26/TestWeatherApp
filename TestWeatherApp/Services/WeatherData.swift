//
//  WeatherData.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//
import Foundation

struct WeatherData: Codable, Equatable {
    let coord: Coordinate
    let name: String
    let main: Main
    let weather: [Weather]
    
    struct Coordinate: Codable, Equatable {
        let lon: Double
        let lat: Double
    }
    
    struct Main: Codable, Equatable {
        let temp: Double
    }
    
    struct Weather: Codable, Equatable {
        let description: String
        let icon: String
    }
}
