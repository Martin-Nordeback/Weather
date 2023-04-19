
//reading weather and finds equal predefined apple icons

import Foundation

enum WeatherIcon {
    case clear
    case clouds
    case rain
    case unknown

    var systemName: String {
        switch self {
        case .clear:
            return "sun.max"
        case .clouds:
            return "cloud.fill"
        case .rain:
            return"cloud.rain.fill"
        case .unknown:
            return "questionmark"
        }
    }

    init(condition: String) {
        switch condition.lowercased() {
        case "clear":
            self = .clear
        case "clouds":
            self = .clouds
        case "rain":
            self = .rain
        default:
            self = .unknown
        }
    }
}
