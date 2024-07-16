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
		var isShowingLookAround = false
		var checkedInProfiles: [CKRecord.ID: Int] = [:]
		var cameraPosition: MapCameraPosition = .region(
			.init(
				center: CLLocationCoordinate2D(
					latitude: 37.331516,
					longitude: -121.891054
				),
				latitudinalMeters: 1200,
				longitudinalMeters: 1200
			)
		)
		var lookAroundScene: MKLookAroundScene? {
			didSet {
				if let _ = lookAroundScene {
					isShowingLookAround = true
				}
			}
		}
		var route: MKRoute?
		
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
//				region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
				cameraPosition = .region(.init(center: currentLocation.coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200))
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
		
		
		@MainActor
		func getLookAroundScene(for location: DDGLocation) {
			Task {
				let request = MKLookAroundSceneRequest(coordinate: location.location.coordinate)
				lookAroundScene = try? await request.scene
			}
		}
		
		@MainActor
		func getDirections(to location: DDGLocation) {
			guard let userLocation = deviceLocationManager.location?.coordinate else { return }
			let destination = location.location.coordinate
			
			let request = MKDirections.Request()
			request.source = MKMapItem(placemark: .init(coordinate: userLocation))
			request.destination = MKMapItem(placemark: .init(coordinate: destination))
			request.transportType = .walking
			
			Task {
				let directions = try? await MKDirections(request: request).calculate()
				route = directions?.routes.first
			}
		}
	}
}
