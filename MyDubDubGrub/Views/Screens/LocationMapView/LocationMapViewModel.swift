//
//  LocationMapViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import MapKit
import CloudKit
import SwiftUI

final class LocationMapViewModel: ObservableObject {
	// MARK: - Properties
	@Published var alertItem: AlertItem?
	@Published var region = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
		span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
	)
	@Published var isShowingDetailView = false
	@Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
	
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
	
	func getCheckedInCounts() {
		CloudKitManager.shared.getCheckedInProfilesCount { result in
			DispatchQueue.main.async {
				switch result {
					case .success(let checkedInProfiles):
						self.checkedInProfiles = checkedInProfiles
					case .failure(_):
						break
				}
			}
		}
	}
	
	func createMapViewVoiceOverSummary(for location: DDGLocation) -> String {
		let count = checkedInProfiles[location.id, default: 0]
		let personPlurality = count == 1 ? "Person" : "People"
		
		return "\(location.name) \(count) \(personPlurality) checked in."
	}
	
	@ViewBuilder
	func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View {
		if sizeCategory >= .accessibilityMedium {
			LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
		} else {
			LocationDetailView(viewModel: LocationDetailViewModel(location: location))
		}
	}
}
