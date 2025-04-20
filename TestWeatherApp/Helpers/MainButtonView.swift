//
//  MainButtonView.swift
//  TestWeatherApp
//
//  Created by Роман Главацкий on 20.04.2025.
//

import SwiftUI

struct MainButtonView: View {
    var text: String = ""
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.orange)
            Text(text)
                .foregroundStyle(.black)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.5)
                .padding()
        }.frame(height: 60)
    }
}

#Preview {
    MainButtonView(text: "Save")
}
