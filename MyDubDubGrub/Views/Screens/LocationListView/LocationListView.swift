//
//  LocationListView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationListView: View {
	// MARK: - Environment
	@Environment(\.sizeCategory) var sizeCategory
	@EnvironmentObject private var locationManager: LocationManager
	
	// MARK: - State
	@StateObject private var viewModel = LocationListViewModel()
	
    var body: some View {
		List {
			ForEach(locationManager.locations) { location in
				NavigationLink(destination: viewModel.createLocationDetailView(for: location, in: sizeCategory)) {
					LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
						.accessibilityElement(children: .ignore)
						.accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
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

