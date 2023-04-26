# Simple Weather App in SwiftUI

This is a simple weather app built in SwiftUI that shows current local weather and 5-day forecast. It uses two different APIs from OpenWeatherMap, one for local weather and another for the 5-day forecast.

## Features

- Display current local weather and 5-day forecast.
- Dark mode and light mode support.
- The display mode changes based on `isDayTime = hour >= 6 && hour < 18`.

## Installation

1. Clone this repository to your local machine.
2. Open the project in Xcode.
3. In the `WeatherService.swift` file, replace `API_KEY` with your OpenWeatherMap API key.
4. Build and run the app in Xcode.

## Usage

- On the main screen, you can see the current local weather, including the temperature, weather condition, and wind speed.
- Scroll down to see the 5-day forecast.
- The app supports both dark mode and light mode. The display mode changes automatically based on `isDayTime = hour >= 6 && hour < 18`.

## Screenshots

<img src="https://github.com/Martin-Nordeback/Weather/blob/main/MyWeatherApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202023-04-25%20at%2008.08.13.png?raw=true" alt="Calculator" style="width: 40%; height: auto;"> <img src="https://github.com/Martin-Nordeback/Weather/blob/main/MyWeatherApp/Screenshots/Simulator%20Screenshot%20-%20iPhone%2014%20Pro%20-%202023-04-26%20at%2010.57.40.png?raw=true" alt="Calculator" style="width: 40%; height: auto;">


## Credits

This app was built using the following technologies:

- Swift 5.8
- SwiftUI
- OpenWeatherMap API

## License

This project has no licenses.
