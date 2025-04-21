//
//  ContentView.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack{
            GradientBackgroundView()
            if !networkMonitor.isConnected {
                NoInternetView()
            } else {
                VStack {
                    //MARK: - Weather info
                    WeatherInfoView(viewModel: viewModel)
                    
                    //MARK: - Find city
                    TextFieldCityView(city: $viewModel.city) {
                        viewModel.tapToGetWeatherForCity()
                    }
                    .focused($isFocused)
                    
                    Spacer()
                    
                    //MARK: - Get weather button
                    Button {
                        viewModel.tabToGetWeatheryourLocation()
                    } label: {
                        MainButtonView(text: "Get weather for your location")
                    }
                    
                    //MARK: - Status / Errors
                    if let status = locationManager.authorizationStatus, status == .denied {
                        Text("Please allow location access in settings.")
                            .foregroundStyle(.red)
                    } else if viewModel.weather == nil {
                        Text("No data yet...")
                            .foregroundStyle(.gray)
                    }
                }
                .padding()
                
            }
        }
        .animation(.easeInOut, value: viewModel.weather)
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
