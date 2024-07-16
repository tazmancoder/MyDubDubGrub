//
//  LocationMapViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import MapKit
import CloudKit
import SwiftUI
import Observation

extension LocationMapView {
	// If you put your view models inside an extension of the view it's meant for
	// then thats the only place you can initialize that view model. You don't want
	// to pass the view model all around your app.
	
	@Observable
	final class LocationMapViewModel: NSObject, CLLocationManagerDelegate {
		// MARK: - Properties
		var alertItem: AlertItem?
		var isShowingDetailView = false
		var checkedInProfiles: [CKRecord.ID: Int] = [:]
		var region = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
			span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		)
		
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
		
		
		@MainActor 
		func getLocations(for locationManager: LocationManager) {
			Task {
				do {
					locationManager.locations = try await CloudKitManager.shared.getLocations()
				} catch {
					alertItem = AlertContext.unableToGetLocations
				}
			}
		}
		
		
		@MainActor 
		func getCheckedInCounts() {
			Task {
				do {
					checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
				} catch {
					alertItem = AlertContext.checkedInCount
				}
			}
		}
		
		
		func createMapViewVoiceOverSummary(for location: DDGLocation) -> String {
			let count = checkedInProfiles[location.id, default: 0]
			let personPlurality = count == 1 ? "Person" : "People"
			
			return "\(location.name) \(count) \(personPlurality) checked in."
		}
		
		
		@MainActor
		@ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
			if dynamicTypeSize >= .accessibility3 {
				LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
			} else {
				LocationDetailView(viewModel: LocationDetailViewModel(location: location))
			}
		}
	}
}
