/*
 In summary, this class manages location-related tasks,
 provides a published location property to store the user's current location,
 and uses the isLoading flag to indicate whether a location request is in progress.
 */

// MARK: This class is responsible for managing location-related tasks

import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    // In the init() method, the delegate is set to self, which means that this class will be responsible for receiving location-related events.
    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
}
