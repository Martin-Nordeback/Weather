/*
 
 If the user's location is available (locationManager.location is not nil), it checks whether the weather data is available (weather is not nil). If the weather data is available, it displays a WeatherView with the weather information. Otherwise, it displays a LoadingView while the app retrieves the weather data asynchronously using the weatherManager.

 If the user's location is not available, it checks whether the locationManager is still loading the location. If it is, it displays a LoadingView. Otherwise, it displays a WelcomeView that prompts the user to enable location access.
 
 */

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
                if let weather = weather, let forecast = forecast {
                    let forecastResponse = forecast.map { item in
                        ForecastResponse(list: [item])
                    }
                    WeatherView(weather: weather, forecast: forecastResponse)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager
                                    .getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                let forecastItems = try await weatherManager
                                    .getWeatherForecast(latitude: location.latitude, longitude: location.longitude)
                                forecast = forecastItems

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
        //changing theme if day/night, light/dark
        .background(isDayTime ? Color(
            hue: 0.588, saturation: 0.739, brightness: 0.962) : Color(
            hue: 0.665, saturation: 0.917, brightness: 0.262))
        .preferredColorScheme(isDayTime ? .light : .dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
