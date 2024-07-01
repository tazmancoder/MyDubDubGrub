//
//  LocationMapViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import MapKit
import CoreLocation

final class LocationMapViewModel: NSObject, ObservableObject {
	// MARK: - Properties
	@Published var isShowingOnboardView = false
	@Published var alertItem: AlertItem?
	@Published var region = MKCoordinateRegion(
		center: CLLocationCoordinate2D(
			latitude: 37.331516,
			longitude: -121.891054
		),
		span: MKCoordinateSpan(
			latitudeDelta: 0.01,
			longitudeDelta: 0.01
		)
	)
	
	var deviceLocationManager: CLLocationManager?
	let kHasSeenOnboardView = "hasSeenOnboardView"
	
	var hasSeenOnboardView: Bool {
		return UserDefaults.standard.bool(forKey: kHasSeenOnboardView)
	}
	
	// MARK: - Functions
	func runStartUpChecks() {
		if !hasSeenOnboardView {
			isShowingOnboardView = true
			UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
		} else {
			checkIfLocationServicesIsEnabled()
		}
	}
	
	func checkIfLocationServicesIsEnabled() {
		if CLLocationManager.locationServicesEnabled() {
			self.deviceLocationManager = CLLocationManager()
			self.deviceLocationManager!.delegate = self
		} else {
			self.alertItem = AlertContext.locationDisabled
		}
	}
	
	private func checkLocationAuthorization() {
		guard let deviceLocationManager = deviceLocationManager else { return }
		
		switch deviceLocationManager.authorizationStatus {
		case .notDetermined:
			deviceLocationManager.requestWhenInUseAuthorization()
		case .restricted:
			alertItem = AlertContext.locationRestricted
		case .denied:
			alertItem = AlertContext.locationDenied
		case .authorizedAlways, .authorizedWhenInUse:
			break
		@unknown default:
			break
		}
	}
	
	func getLocations(for locationManager: LocationManager) {
		CloudKitManager.shared.getLocations { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let locations):
					locationManager.locations = locations
				case .failure(_):
					self.alertItem = AlertContext.unableToGetLocations
				}
			}
		}
	}
}

extension LocationMapViewModel: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}
}
