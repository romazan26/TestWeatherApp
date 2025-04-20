//
//  WeatherInfoView.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import SwiftUI

struct WeatherInfoView: View {
    @StateObject var viewModel: WeatherViewModel
    var body: some View {
        VStack {
            if let weather = viewModel.weather {
                //MARK: - Name location
                HStack {
                    Text("\(weather.name)")
                        .font(.system(size: 38, weight: .heavy, design: .monospaced))
                    Spacer()
                }
                //MARK: - Image weather
                ZStack {
                    Rectangle()
                        .fill(Color.clear) // Резервируем место для изображения
                        .frame(width: 200, height: 200)
                    
                    if viewModel.isLoading {
                        ProgressView("Loading weather data...")
                            .font(.headline)
                            .padding()
                    }else{
                        if let url = viewModel.weatherIconURL {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                } else if phase.error != nil {
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.red)
                                } else {
                                    ProgressView()
                                }
                            }
                        } else {
                            ZStack {
                                Image(systemName: "cloud")
                                    .resizable()
                                    .scaledToFit()
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(20)
                            }
                            .frame(width: 200, height: 200)
                        }
                    }
                }
                
                //MARK: - Description weather
                Text(weather.weather.first?.description.capitalized ?? "")
                    .font(.system(size: 25, weight: .light, design: .serif))
                
                //MARK: - Temperature
                HStack {
                    Text("\(viewModel.displayedTemperature)")
                        .font(.system(size: 38, weight: .heavy, design: .monospaced))
                    Spacer()
                    Button("Celsius / Fahrenheit") {
                        viewModel.toggleUnitsButtonTapped()
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                }
                
            }
        }
    }
}

#Preview {
    WeatherInfoView(viewModel: WeatherViewModel())
}
