//
//  LocationDetailViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/2/24.
//

import Foundation
import SwiftUI
import MapKit

final class LocationDetailViewModel: ObservableObject {
	// MARK: - Published Properties
	@Published var alertItem: AlertItem? = nil
	@Published var isShowingProfileModal = false
	
	// MARK: - Grid Items
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	// MARK: - Properties
	var location: DDGLocation
	
	init(location: DDGLocation) {
		self.location = location
	}
	
	// MARK: - Functions
	func getDirectionsToLocation() {
		let placemark = MKPlacemark(coordinate: location.location.coordinate)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = location.name
		
		mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
	}
	
	func callLocation() {
		guard let url = URL(string: "tel://\(location.phoneNumber)") else {
			alertItem = AlertContext.invalidPhoneNumber
			return
		}
		UIApplication.shared.open(url)
	}
}
