
import SwiftUI

// UI for the weakly view

struct WeekWeatherRow: View {
    var name: String
    var value: String
    var condition: String

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: WeatherIcon(condition: condition).systemName)
                .font(.title2)
                .frame(width: 18, height: 18)
                .padding()
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)
            Text(name)
                .font(.caption)
            Text(value)
                .bold()
        }
    }
}

struct WeekWeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeekWeatherRow(name: "Week day", value: "8°", condition: "system")
    }
}
