/*
 
 The view displays information about the weather in a given location, using a model object of type "ResponseBody" & an array from the upcoming days [ForecastResponse] which is passed as a parameter to the view.
 
 */

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    var forecast: [ForecastResponse]

    @State private var isDayTime = false

    //By initializing a "WeatherView" object with the necessary data, the view can be updated with the latest weather information and forecast data.
    init(weather: ResponseBody, forecast: [ForecastResponse]) {
        self.weather = weather
        self.forecast = forecast
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weather.name)
                        .bold().font(.title)

                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                .padding(.leading)

                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: WeatherIcon(condition: weather.weather[0].main).systemName)
                                .font(.system(size: 60))
                            Text(weather.weather[0].main)
                        }
                        .frame(width: 150, alignment: .leading)

                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 90))
                            .fontWeight(.bold)
                            .padding()
                    }

                    Spacer()

                    ZStack {
                        if isDayTime {
                            Image(systemName: "sun.max.fill")
                                .resizable()
                                .foregroundColor(.yellow)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .shadow(color: .yellow, radius: 50, x: 0.0, y: 0.0)
                        } else {
                            Image(systemName: "moon.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .shadow(color: .yellow, radius: 40, x: 0.0, y: 0.0)
                        }
                    }
                    .onAppear {
                        let hour = Calendar.current.component(.hour, from: Date())
                        self.isDayTime = hour >= 6 && hour < 18
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Weather now")
                            .bold()
                            .padding(.bottom)

                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: weather.main.tempMin.roundDouble() + "°")
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: weather.main.tempMax.roundDouble() + "°")
                        }

                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: weather.wind.speed.roundDouble() + " m/s")
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                        }

                        Text("Upcoming days")
                            .bold()

                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(forecast) { forecast in
                                    WeekWeatherRow(name: "\(forecast.list[0].date)", value: "\(forecast.list[0].main.temperature.rounded())°",
                                                   condition: forecast.list[0].weather[0].main)
                                }
                            }
                        }
                    }
                    .padding()
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.bottom)
        .background(isDayTime ? Color(hue: 0.588, saturation: 0.739, brightness: 0.962) : Color(hue: 0.665, saturation: 0.917, brightness: 0.262))
        .preferredColorScheme(isDayTime ? .light : .dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        let forecast = [ForecastResponse]()
        WeatherView(weather: previewWeather, forecast: forecast)
    }
}
