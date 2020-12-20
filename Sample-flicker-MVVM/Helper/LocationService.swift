//
//  LocationService.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationDidUpdate(_ currentLocation: CLLocation)
    func locationDidFail(_ error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationService()
    var delegate: LocationServiceDelegate?
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            print("LocationManager Location denied")
            break
        case .authorizedAlways:
            print("LocationManager Location authorizedAlways")
            break
        default:
            break
        }
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }

    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        if let _ = self.lastLocation {
            print("if")
        } else {
            print("else")
            self.lastLocation = location // use for real time update location
            updateLocation(location)
        }
        self.locationManager?.stopUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error)
    }

    private func updateLocation(_ currentLocation: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.locationDidUpdate(currentLocation)
    }

    private func updateLocationDidFailWithError(_ error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.locationDidFail(error)
    }
}

