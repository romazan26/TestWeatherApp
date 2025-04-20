//
//  TextFieldCityView.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import SwiftUI

struct TextFieldCityView: View {
    
    @Binding var city: String
    var action: () -> Void = {}
    
    var body: some View {
        HStack {
            TextField("Enter your city", text: $city)
                Spacer()
            Button {
                action()
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.orange)
            }
        }
        .padding()
        .background {
            Color.white.cornerRadius(8)
        }
    }
}

#Preview {
    TextFieldCityView(city: .constant(""))
}
