//
//  WeatherService.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import Foundation
import CoreLocation



protocol NetworkSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

protocol WeatherServiceProtocol {
    func fetchWeather(
        lat: Double,
        lon: Double,
        units: String,
        completion: @escaping (Result<WeatherData, Error>) -> Void
    )
    
    func fetchWeatherForCity(
        for city: String,
        units: String,
        completion: @escaping (Result<WeatherData, Error>) -> Void
    )
}

extension URLSession: NetworkSession {}


final class WeatherService: WeatherServiceProtocol {
    private let apiKey = Bundle.main.infoDictionary?["WeatherAPIKey"] as? String ?? ""
    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchWeather(lat: Double, lon: Double, units: String = "metric", completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let url = makeURL(lat: lat, lon: lon, units: units) else {
            return
        }
        performRequest(url: url, completion: completion)
    }
    
    func fetchWeatherForCity(for city: String, units: String = "metric", completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let url = makeCityURL(city: city, units: units) else {
            return
        }
        performRequest(url: url, completion: completion)
    }
    
    private func makeURL(lat: Double, lon: Double, units: String) -> URL? {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(units)"
        return URL(string: urlString)
    }
    
    private func makeCityURL(city: String, units: String) -> URL? {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&appid=\(apiKey)&units=\(units)"
        return URL(string: urlString)
    }
    
    private func performRequest(url: URL, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


