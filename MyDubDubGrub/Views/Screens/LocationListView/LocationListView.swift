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
	@StateObject private var viewModel = LocationListViewModel()
	
    var body: some View {
		List {
			ForEach(locationManager.locations) { location in
				NavigationLink(
					destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))
				) {
					LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
				}
			}
		}
		.listStyle(.plain)
		.navigationTitle("Grub Spots")
		.onAppear { viewModel.getCheckInProfilesDictionary() }
    }
}

//#Preview {
//	NavigationView {
//		LocationListView()
//	}
//}

