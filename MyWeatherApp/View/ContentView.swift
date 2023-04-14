//
//  ContentView.swift
//  MyWeatherApp
//
//  Created by Martin Nordebäck on 2023-04-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            WelcomeView()
                .environmentObject(locationManager)
        }
        .background(Color(hue: 0.665, saturation: 0.917, brightness: 0.262))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
