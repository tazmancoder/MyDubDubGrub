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
				MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
					DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
						.accessibilityLabel(Text("Map Pin \(location.name) \(viewModel.checkedInProfiles[location.id, default: 0]) people checked in."))
						.onTapGesture {
							locationManager.selectedLocation = location
							viewModel.isShowingDetailView = true
						}
				}
			}
			.accentColor(Color.red)
			.ignoresSafeArea()
			
			VStack {
				LogoView(frameWidth: 125)
					.shadow(radius: 10)
					.accessibilityHidden(true)
				Spacer()
			}
		}
		.sheet(isPresented: $viewModel.isShowingDetailView) {
			NavigationView {
				LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
					.toolbar {
						Button(action: { viewModel.isShowingDetailView = false }, label: { XDismissButton() })
					}
			}
		}
		.alert(item: $viewModel.alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.onAppear {			
			if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
			viewModel.getCheckedInCounts()
		}
	}
}

//#Preview {
//    LocationMapView()
//}
