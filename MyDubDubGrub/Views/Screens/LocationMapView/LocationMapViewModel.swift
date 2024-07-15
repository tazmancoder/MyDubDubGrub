//
//  LocationMapViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView {
	// If you put your view models inside an extension of the view it's meant for
	// then thats the only place you can initialize that view model. You don't want
	// to pass the view model all around your app.
	
	@MainActor final class LocationMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
		// MARK: - Properties
		@Published var alertItem: AlertItem?
		@Published var region = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
			span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		)
		@Published var isShowingDetailView = false
		@Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
		
		
		let deviceLocationManager = CLLocationManager()
		
		override init() {
			super.init()
			deviceLocationManager.delegate = self
		}
		
		
		func requestAllowOnceLocationPermission() {
			deviceLocationManager.requestLocation()
		}
		
		
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			guard let currentLocation = locations.last else {
				alertItem = AlertContext.locationNotFound
				return
			}
			
			withAnimation {
				region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
			}
		}
		
		
		func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
			alertItem = AlertContext.didFailToGetLocation
		}
		
		
		func getLocations(for locationManager: LocationManager) {
			Task {
				do {
					locationManager.locations = try await CloudKitManager.shared.getLocations()
				} catch {
					alertItem = AlertContext.unableToGetLocations
				}
			}
		}
		
		
		func getCheckedInCounts() {
			Task {
				do {
					checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
				} catch {
					alertItem = AlertContext.checkedInCount
				}
			}
//			CloudKitManager.shared.getCheckedInProfilesCount { result in
//				DispatchQueue.main.async { [self] in
//					switch result {
//						case .success(let checkedInProfiles):
//							self.checkedInProfiles = checkedInProfiles
//						case .failure(_):
//							alertItem = AlertContext.checkedInCount
//					}
//				}
//			}
		}
		
		
		func createMapViewVoiceOverSummary(for location: DDGLocation) -> String {
			let count = checkedInProfiles[location.id, default: 0]
			let personPlurality = count == 1 ? "Person" : "People"
			
			return "\(location.name) \(count) \(personPlurality) checked in."
		}
		
		
		@ViewBuilder
		func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
			if dynamicTypeSize >= .accessibility3 {
				LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
			} else {
				LocationDetailView(viewModel: LocationDetailViewModel(location: location))
			}
		}
	}
}
