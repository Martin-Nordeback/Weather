//
//  WeatherManagerAPI.swift
//  MyWeatherApp
//
//  Created by Martin Nordebäck on 2023-04-14.
//

import CoreLocation
import Foundation

class WeatherManager {
    // MARK: API FOR CURRENT WEATHER

    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=17fa258a1f4f333c53a6161a066e886c&units=metric") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }

        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }

    // MARK: API FOR FORECAST 5-DAYS

    func getWeatherForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [ForecastItem] {
        guard let url = URL(string:
            "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=1a3d402ebb97dbcb6fb058da433289cc&units=metric") else { fatalError("Missing Forecast URL") }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching forecast weather data") }

        let decodedData = try JSONDecoder().decode(ForecastResponse.self, from: data)
        return decodedData.list
    }
}

// DRY!! + take it away from this scope
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }

    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}

struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable {
    let date: Date
    let main: MainResponse
    let weather: [WeatherResponse]
    let wind: WindResponse

    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case main
        case weather
        case wind
    }

    struct MainResponse: Decodable {
        let temperature: Double
        let pressure: Double
        let humidity: Double

        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case pressure
            case humidity
        }
    }

    struct WeatherResponse: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct WindResponse: Decodable {
        let speed: Double
        let degrees: Double

        enum CodingKeys: String, CodingKey {
            case speed
            case degrees = "deg"
        }
    }
}
