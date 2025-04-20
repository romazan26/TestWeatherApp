//
//  TemperatureUnit.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

enum TemperatureUnit: String, CaseIterable {
    case metric = "metric"
    case imperial = "imperial"
    
    var symbol: String {
        switch self {
        case .metric:
            return "°C"
        case .imperial:
            return "°F"
        }
    }
}
