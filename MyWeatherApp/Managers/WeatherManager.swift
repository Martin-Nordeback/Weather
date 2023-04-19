/*
 
 
 
 */

import CoreLocation
import Foundation

class WeatherManager {
    // MARK: API FOR CURRENT WEATHER
    
    private let apiKey = "17fa258a1f4f333c53a6161a066e886c"

    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }

        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }

    // MARK: API FOR FORECAST 5-DAYS

    func getWeatherForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [ForecastItem] {
        guard let url = URL(string:
            "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing Forecast URL") }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching forecast weather data") }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.forecastDateFormatter)
        let decodedData = try decoder.decode(ForecastResponse.self, from: data)
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

/* --------------------------------------- */

struct ForecastResponse: Decodable, Identifiable, Hashable {
    var id = UUID()
    let list: [ForecastItem]

    enum CodingKeys: String, CodingKey {
        case list
    }
}

struct ForecastItem: Decodable, Hashable, Identifiable {
    var id = UUID()
    var date: String
    let main: MainResponse
    let weather: [WeatherResponse]
    let wind: WindResponse

    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case main
        case weather
        case wind
    }

    struct MainResponse: Decodable, Hashable {
        let temperature: Double
        let pressure: Double
        let humidity: Double

        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case pressure
            case humidity
        }
    }

    struct WeatherResponse: Decodable, Hashable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct WindResponse: Decodable, Hashable {
        let speed: Double
        let degrees: Double

        enum CodingKeys: String, CodingKey {
            case speed
            case degrees = "deg"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        main = try container.decode(MainResponse.self, forKey: .main)
        weather = try container.decode([WeatherResponse].self, forKey: .weather)
        wind = try container.decode(WindResponse.self, forKey: .wind)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: ForecastItem, rhs: ForecastItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DateFormatter {
    static let forecastDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
}
