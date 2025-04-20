//
//  MockData.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import Foundation
@testable import TestWeatherApp

//MARK: - WeatherService
final class MockWeatherService: WeatherServiceProtocol {
    var mockResult: Result<WeatherData, Error>?

    func fetchWeather(lat: Double, lon: Double, units: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }

    func fetchWeatherForCity(for city: String, units: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}

//MARK: - CacheManager
final class MockCacheManager: CacheManagerProtocol {
    var savedData: WeatherData?
    var loadedData: WeatherData?

    func save(_ data: WeatherData) {
        savedData = data
    }

    func load() -> WeatherData? {
        return loadedData
    }
}

//MARK: - URLSession
final class MockURLSession: NetworkSession {
    var testData: Data?
    var testError: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        MockURLSessionDataTask { [self] in
            completionHandler(testData, nil, testError)
        }
    }
}

final class MockURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    override func resume() {
        closure()
    }
}

