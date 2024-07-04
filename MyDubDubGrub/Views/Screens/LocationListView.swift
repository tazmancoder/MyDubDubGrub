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
				NavigationLink(
					destination: LocationDetailView(
						viewModel: LocationDetailViewModel(location: location)
					)
				) {
					LocationCell(location: location)
				}
			}
		}
		.listStyle(.plain)
		.navigationTitle("Grub Spots")
		.onAppear {
			CloudKitManager.shared.getCheckedInProfilesDictionary { result in
				switch result {
				case .success(let checkedInProfiles):
					print(checkedInProfiles)
				case .failure(_):
					print("❌ Error getting back dictionary")
				}
			}
		}
    }
}

#Preview {
	NavigationView {
		LocationListView()
	}
}

