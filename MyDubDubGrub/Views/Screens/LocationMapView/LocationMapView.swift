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
	@Environment(\.sizeCategory) var sizeCategory
	
	// MARK: - State
	@StateObject private var viewModel = LocationMapViewModel()
	
	var body: some View {
		ZStack(alignment: .top) {
			
			Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
				MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
					DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
						.accessibilityLabel(Text(viewModel.createMapViewVoiceOverSummary(for: location)))
						.onTapGesture {
							locationManager.selectedLocation = location
							viewModel.isShowingDetailView = true
						}
				}
			}
			.accentColor(Color.red)
			.ignoresSafeArea()
			
			LogoView(frameWidth: 125)
				.shadow(radius: 10)
				.accessibilityHidden(true)
		}
		.sheet(isPresented: $viewModel.isShowingDetailView) {
			NavigationView {
				viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: sizeCategory)
					.toolbar { Button(action: { viewModel.isShowingDetailView = false }, label: { XDismissButton() }) }
			}
		}
		.alert(item: $viewModel.alertItem) { $0.alert }
		.onAppear {
			if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
			viewModel.getCheckedInCounts()
		}
	}
}

#Preview {
	LocationMapView().environmentObject(LocationManager())
}
