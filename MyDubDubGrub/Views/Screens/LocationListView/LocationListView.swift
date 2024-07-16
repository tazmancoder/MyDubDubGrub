//
//  LocationListView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationListView: View {
	// MARK: - Environment
	@Environment(\.dynamicTypeSize) var dynamicTypeSize
	@EnvironmentObject private var locationManager: LocationManager
	
	// MARK: - State
	@StateObject private var viewModel = LocationListViewModel()
	
    var body: some View {
		List {
			ForEach(locationManager.locations) { location in
				NavigationLink(value: location) {
					LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
						.accessibilityElement(children: .ignore)
						.accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
				}
			}
		}
		.listStyle(.plain)
		.navigationTitle("Grub Spots")
		.navigationDestination(for: DDGLocation.self) { location in
			viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)
		}
		.task { await viewModel.getCheckInProfilesDictionary() }
		.refreshable { await viewModel.getCheckInProfilesDictionary() }
		.alert(item: $viewModel.alertItem) { $0.alert }
    }
}

#Preview {
	NavigationStack {
		LocationListView()
			.environmentObject(LocationManager())
	}
}

