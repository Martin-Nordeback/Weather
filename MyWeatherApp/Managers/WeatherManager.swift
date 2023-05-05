/*

 Summary, this code demonstrates how to use asynchronous networking and JSON decoding in Swift to retrieve and parse weather data from an API.

 */

import CoreLocation
import Foundation

// MARK: - Constants

private let currentWeatherEndpoint = "https://api.openweathermap.org/data/2.5/weather"
private let weatherForecastEndpoint = "https://api.openweathermap.org/data/2.5/forecast"
private let apiKey = ""

// MARK: - Error Types

enum WeatherManagerError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

// MARK: - Weather Manager

class WeatherManager {
    // MARK: API FOR CURRENT WEATHER

    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        let urlString = "\(currentWeatherEndpoint)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw WeatherManagerError.invalidURL }

        let data = try await fetchData(from: url)
        let decodedData = try decodeJSONData(data, toType: ResponseBody.self)
        return decodedData
    }

    // MARK: API FOR FORECAST 5-DAYS

    func getWeatherForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [ForecastItem] {
        let urlString = "\(weatherForecastEndpoint)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { throw WeatherManagerError.invalidURL }

        let data = try await fetchData(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.forecastDateFormatter)
        let decodedData = try decodeJSONData(data, toType: ForecastResponse.self)
        return decodedData.list
    }

    // MARK: - Private Functions

    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw WeatherManagerError.invalidResponse }
        return data
    }

    private func decodeJSONData<T: Decodable>(_ data: Data, toType type: T.Type) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        } catch {
            throw WeatherManagerError.decodingError
        }
    }
}

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

        enum CodingKeys: String, CodingKey {
            case temp, feels_like, temp_min, temp_max, pressure, humidity
        }

        var feelsLike: Double { return feels_like }
        var tempMin: Double { return temp_min }
        var tempMax: Double { return temp_max }
    }

    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

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

        var tempMin: Double { return temperature }
        var tempMax: Double { return temperature }
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

    static func == (lhs: ForecastItem, rhs: ForecastItem) -> Bool {
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
