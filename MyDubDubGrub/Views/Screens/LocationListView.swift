//
//  LocationListView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationListView: View {
	// MARK: - EnvironmentObject
	@EnvironmentObject private var locationManager: LocationManager
	
    var body: some View {
		List {
			ForEach(locationManager.locations) { location in
				NavigationLink(destination: LocationDetailView(location: location)) {
					LocationCell(location: location)
				}
			}
		}
		.navigationTitle("Grub Spots")
    }
}

#Preview {
	NavigationView {
		LocationListView()
	}
}

