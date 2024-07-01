//
//  LocationMapView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

// San Jose Conventions Center Cooridnates
// Latitue: 37.331516
// Longitude: -121.891054

import SwiftUI
import MapKit

struct LocationMapView: View {
	// MARK: - Environment Objects
	@EnvironmentObject private var locationManager: LocationManager
	
	// MARK: - State
	@StateObject private var viewModel = LocationMapViewModel()
	
    var body: some View {
		ZStack {
			Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
				MapMarker(coordinate: location.location.coordinate, tint: .brandPrimary)
			}
			.accentColor(Color.red)
			.ignoresSafeArea()
			
			VStack {
				LogoView(frameWidth: 125)
					.shadow(radius: 10)
				Spacer()
			}
		}
		.alert(item: $viewModel.alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.onAppear {
			viewModel.checkIfLocationServicesIsEnabled()
			
			if locationManager.locations.isEmpty {
				viewModel.getLocations(for: locationManager)
			}
		}
    }
}

#Preview {
    LocationMapView()
}
