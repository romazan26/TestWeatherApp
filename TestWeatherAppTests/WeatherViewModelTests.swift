//
//  WeatherViewModelTests.swift
//  TestWeatherAppTests
//
//  Created by Роман Главацкий on 20.04.2025.
//

import XCTest
@testable import TestWeatherApp

final class WeatherViewModelTests: XCTestCase {
    var mockService: MockWeatherService!
    var mockCache: MockCacheManager!
    var viewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        mockCache = MockCacheManager()
        viewModel = WeatherViewModel(service: mockService, cache: mockCache, locationManager: LocationManager())
    }

    override func tearDown() {
        mockService = nil
        mockCache = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchWeatherForCity_Success() {
        // Arrange
        let expectedData = WeatherData(
            coord: .init(lon: 37.62, lat: 55.75),
            name: "Moscow",
            main: .init(temp: 14.0),
            weather: [WeatherData.Weather(description: "Cloudy", icon: "04d")]
        )
        mockService.mockResult = .success(expectedData)

        // Act
        viewModel.city = "Moscow"
        viewModel.tapToGetWeatherForCity()

        // Assert (asynchronous waiting)
        let expectation = XCTestExpectation(description: "Wait for weather fetch")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.weather?.name, "Moscow")
            XCTAssertEqual(self.mockCache.savedData?.name, "Moscow")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherForCity_Failure() {
        // Arrange
        mockService.mockResult = .failure(URLError(.notConnectedToInternet))

        // Act
        viewModel.city = "Paris"
        viewModel.tapToGetWeatherForCity()

        // Assert
        let expectation = XCTestExpectation(description: "Wait for failure")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.errorMessage, "No internet connection.")
            XCTAssertNil(self.viewModel.weather)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
