//
//  WeatherServiceTests.swift
//  TestWeatherAppTests
//
//  Created by Роман Главацкий on 20.04.2025.
//

import XCTest
@testable import TestWeatherApp

final class WeatherServiceTests: XCTestCase {
    func testFetchWeatherSuccess() throws {
        let mock = MockURLSession()
        let expected = WeatherData(
            coord: .init(lon: 37.61, lat: 55.75),
            name: "Moscow",
            main: .init(temp: 20),
            weather: [WeatherData.Weather(description: "Sunny", icon: "01d")]
        )
        mock.testData = try JSONEncoder().encode(expected)

        let service = WeatherService(session: mock)
        let expectation = XCTestExpectation(description: "Fetch weather")
        
        service.fetchWeather(lat: 55.75, lon: 37.61) { result in
            if case .success(let data) = result {
                XCTAssertEqual(data.name, expected.name)
            } else {
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
