
import CoreLocationUI
import SwiftUI

struct WelcomeView: View {
    //It uses an @EnvironmentObject property wrapper to access an instance of a LocationManager class.
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("What's the weather like?")
                    .bold().font(.title)

                Text("Please share your current location to get the weather in your area")
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()

            //call the requestLocation function the get the location, rest of the logic is handle in their
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
            }
            .cornerRadius(20)
            .symbolVariant(.fill)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
