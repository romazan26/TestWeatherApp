//
//  NoInternetView.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack{
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 100, height: 100)
            Text("No internet connection")
                .font(.headline)
        }
    }
}

#Preview {
    NoInternetView()
}
