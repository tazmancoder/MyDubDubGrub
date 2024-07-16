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
import CoreLocationUI

struct LocationMapView: View {
	// MARK: - Environment Objects
	@EnvironmentObject private var locationManager: LocationManager
	@Environment(\.dynamicTypeSize) var dynamicTypeSize
	
	// MARK: - State
	@State private var viewModel = LocationMapViewModel()
	
	var body: some View {
		ZStack(alignment: .top) {
			Map(initialPosition: viewModel.cameraPosition) {
				ForEach(locationManager.locations) { location in
					Annotation(location.name, coordinate: location.location.coordinate) {
						DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
							.accessibilityLabel(Text(viewModel.createMapViewVoiceOverSummary(for: location)))
							.onTapGesture {
								locationManager.selectedLocation = location
								viewModel.isShowingDetailView = true
							}
							.contextMenu {
								Button("Look Around", systemImage: "eyes") {
									viewModel.getLookAroundScene(for: location)
								}
								Button("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle") {
									viewModel.getDirections(to: location)
								}
							}
					}
					.annotationTitles(.hidden)
				}
				
				UserAnnotation()
				
				// Will show the user the route to there location
				if let route = viewModel.route {
					MapPolyline(route)
						.stroke(.brandPrimary, lineWidth: 8)
				}
			}
			.tint(.grubRed)
			.lookAroundViewer(isPresented: $viewModel.isShowingLookAround, scene: $viewModel.lookAroundScene)
			.mapStyle(.standard)
			.mapControls {
				MapCompass()
				MapUserLocationButton()
				MapPitchToggle()
				MapScaleView()
			}
			
			LogoView(frameWidth: 125)
				.shadow(radius: 10)
				.accessibilityHidden(true)
		}
		.sheet(isPresented: $viewModel.isShowingDetailView) {
			NavigationStack {
				viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: dynamicTypeSize)
					.toolbar { Button(action: { viewModel.isShowingDetailView = false }, label: { XDismissButton() }) }
			}
		}
		.overlay(alignment: .bottomLeading) {
			LocationButton(.currentLocation) {
				viewModel.requestAllowOnceLocationPermission()
			}
			.foregroundColor(.white)
			.symbolVariant(.fill)
			.tint(.grubRed)
			.labelStyle(.iconOnly)
			.clipShape(Circle())
			.padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
		}
		.alert(item: $viewModel.alertItem) { $0.alert }
		.task {
			if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
			viewModel.getCheckedInCounts()
		}
	}
}

#Preview("Light Mode") {
	LocationMapView().environmentObject(LocationManager())
}

#Preview("Dark Mode") {
	LocationMapView()
		.environmentObject(LocationManager())
		.preferredColorScheme(.dark)
}
