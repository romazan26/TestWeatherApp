//
//  CacheManagerTests.swift
//  TestWeatherAppTests
//
//  Created by Роман Главацкий on 20.04.2025.
//

import XCTest
@testable import TestWeatherApp

final class CacheManagerTests: XCTestCase {
    
    var cacheManager: CacheManager!

    override func setUp() {
        super.setUp()
        cacheManager = CacheManager()
        clearCache()
    }

    override func tearDown() {
        clearCache()
        cacheManager = nil
        super.tearDown()
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: "CachedWeatherData")
    }

    func testSaveAndLoadWeatherData() {
        // Arrange
        let mockData = WeatherData(
            coord: .init(lon: 37.61, lat: 55.75),
            name: "Moscow",
            main: .init(temp: 15.5),
            weather: [
                WeatherData.Weather(description: "Cloudy", icon: "04d")
            ]
        )

        // Act
        cacheManager.save(mockData)
        let loadedData = cacheManager.load()

        // Assert
        XCTAssertEqual(loadedData, mockData, "Загруженные данные должны быть равны сохранённым")
    }
    
    func testLoadEmptyCacheReturnsNil() {

        // Act
        let loadedData = cacheManager.load()

        // Assert
        XCTAssertNil(loadedData, "Если в кеше нет данных, результат должен быть nil")
    }
}
