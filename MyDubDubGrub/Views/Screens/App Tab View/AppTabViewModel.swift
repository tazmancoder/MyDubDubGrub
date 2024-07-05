//
//  AppTabViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject {
	// MARK: - Properties
	@Published var isShowingOnboardView = false
	@Published var alertItem: AlertItem?
	
	var deviceLocationManager: CLLocationManager?
	let kHasSeenOnboardView = "hasSeenOnboardView"
	
	// MARK: - Computed Properties
	var hasSeenOnboardView: Bool { return UserDefaults.standard.bool(forKey: kHasSeenOnboardView) }
	
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
	
	// MARK: - File Private
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
}

extension AppTabViewModel: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}
}
