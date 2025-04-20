//
//  WeatherViewModel.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import Foundation
import CoreLocation
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var units: TemperatureUnit = .metric
    @Published var errorMessage: String?
    @Published var city: String = ""
    @Published var isLoading: Bool = false
    
    private let service: WeatherServiceProtocol
    private let cache: CacheManagerProtocol
    private let locationManager: LocationManager
    private var cancellables: Set<AnyCancellable> = []

    var weatherIconURL: URL? {
        guard let icon = weather?.weather.first?.icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
    
    var displayedTemperature: String {
        guard let tempInCelsius = weather?.main.temp else { return "--" }
        let temperature = units == .metric ? tempInCelsius : (tempInCelsius * 9/5) + 32
        return String(format: "%.1f %@", temperature, units.symbol)
    }
    
    init(service: WeatherServiceProtocol = WeatherService() ,
         cache: CacheManagerProtocol = CacheManager(),
         locationManager: LocationManager = LocationManager()) {
        
        self.service = service
        self.cache = cache
        self.locationManager = locationManager
        
        bindLocationUpdates()
        loadCache()
    }
    
    private func bindLocationUpdates() {
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] coordinate in
                self?.fetchWeatherByLocation(coordinate)
            }
            .store(in: &cancellables)
    }
    
    func tabToGetWeatheryourLocation() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            fetchWeatherByLocation(location)
            errorMessage = nil
        } else {
            errorMessage = "Cannot get your location."
        }
    }
    
    func tapToGetWeatherForCity() {
        fetchWeather(city: city)
        city = ""
    }
    
    func toggleUnitsButtonTapped() {
        units = units == .metric ? .imperial : .metric
    }
    
    private func loadCache() {
        if let cached = cache.load() {
            self.weather = cached
        } else {
            errorMessage = "No cached weather data."
        }
    }
    
    private func fetchWeather(city: String) {
        isLoading = true
        service.fetchWeatherForCity(for: city, units: units.rawValue) { [weak self] result in
            self?.handleWeatherResponse(result)
        }
    }
    
    private func fetchWeatherByLocation(_ location: CLLocationCoordinate2D) {
        isLoading = true
        service.fetchWeather(lat: location.latitude, lon: location.longitude, units: units.rawValue) { [weak self] result in
            self?.handleWeatherResponse(result)
        }
    }
    
    private func handleWeatherResponse(_ result: Result<WeatherData, Error>) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            switch result {
            case .success(let data):
                if data.weather.isEmpty {
                    self?.errorMessage = "No weather data available."
                } else {
                    self?.weather = data
                    self?.cache.save(data)
                }
            case .failure(let error):
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    self?.errorMessage = "No internet connection."
                } else {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
