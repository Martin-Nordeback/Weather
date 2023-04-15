//
//  ContentView.swift
//  MyWeatherApp
//
//  Created by Martin Nordebäck on 2023-04-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var weather: ResponseBody?
    @State private var forecast: [ForecastItem]?
    var weatherManager = WeatherManager()
    @State private var isDayTime = false

    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager
                                    .getCurrentWeather(latitude: location.latitude, longitude: location.longitude)

                            } catch {
                                print("Error getting weather \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(isDayTime ? Color(hue: 0.588, saturation: 0.739, brightness: 0.962) : Color(hue: 0.665, saturation: 0.917, brightness: 0.262))
        .preferredColorScheme(isDayTime ? .light : .dark)
//        .onReceive(locationManager.$location) { location in
//            if let location = location {
//                let now = Date()
//                 let sunrise = location.sunrise
//                 let sunset = location.sunset
//                 isDayTime = now > sunrise && now < sunset
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
