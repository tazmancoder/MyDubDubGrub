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
	// MARK: - State
	@StateObject private var viewModel = LocationMapViewModel()
	
    var body: some View {
		ZStack {
			Map(coordinateRegion: $viewModel.region)
				.ignoresSafeArea()
			
			VStack {
				LogoView()
					.shadow(radius: 10)
				Spacer()
			}
		}
		.alert(item: $viewModel.alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.onAppear {
			viewModel.getLocations()
		}
    }
}

#Preview {
    LocationMapView()
}

struct LogoView: View {
	var body: some View {
		Image(.ddgMapLogo)
			.resizable()
			.scaledToFit()
			.frame(height: 70)
	}
}
