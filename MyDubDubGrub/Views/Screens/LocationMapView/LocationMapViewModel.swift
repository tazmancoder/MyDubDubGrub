//
//  LocationMapViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import MapKit

final class LocationMapViewModel: ObservableObject {
	// MARK: - Properties
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
	@Published var isShowingDetailView = false
		
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
