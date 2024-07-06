//
//  AppTabViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import CoreLocation
import SwiftUI

extension AppTabView {
	final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
		// MARK: - Properties
		@Published var isShowingOnboardView = false
		@Published var alertItem: AlertItem?
		@AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
			didSet { isShowingOnboardView = hasSeenOnboardView }
		}
		
		var deviceLocationManager: CLLocationManager?
		let kHasSeenOnboardView = "hasSeenOnboardView"
				
		// MARK: - Functions
		func runStartUpChecks() {
			if !hasSeenOnboardView {
				hasSeenOnboardView = true
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

		func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
			checkLocationAuthorization()
		}
	}
}
