//
//  CacheManager.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import Foundation

protocol CacheManagerProtocol {
    func save(_ data: WeatherData)
    func load() -> WeatherData?
}

final class CacheManager: CacheManagerProtocol {
    private let cacheKey = "CachedWeatherData"
    
    func save(_ data: WeatherData) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: cacheKey)
        }
    }
    
    func load() -> WeatherData? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode(WeatherData.self, from: data)
    }
}


