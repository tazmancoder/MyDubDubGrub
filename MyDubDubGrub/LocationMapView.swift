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
	@State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
	
    var body: some View {
		ZStack {
			Map(coordinateRegion: $region)
				.ignoresSafeArea()
			
			VStack {
				Image(.ddgMapLogo)
					.resizable()
					.scaledToFit()
					.frame(height: 70)
					.shadow(radius: 10)
					
				Spacer()
			}
		}
    }
}

#Preview {
    LocationMapView()
}
