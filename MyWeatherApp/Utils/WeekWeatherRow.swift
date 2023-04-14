//
//  WeekWeatherRow.swift
//  MyWeatherApp
//
//  Created by Martin Nordebäck on 2023-04-14.
//

import SwiftUI

struct WeekWeatherRow: View {
    var logo: String
    var name: String
    var value: String
    var day: String = ""

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)
            Text(name)
                .font(.caption)
            Text(value)
                .bold()
                
            Text(day)
                .font(.caption)
        }
    }
}

struct WeekWeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeekWeatherRow(logo: "thermometer", name: "Feels like", value: "8°", day: "day")
    }
}
