//
//  LocationListView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationListView: View {
	// MARK: - State
	@State private var locations: [DDGLocation] = [DDGLocation(record: MockData.location), DDGLocation(record: MockData.location1), DDGLocation(record: MockData.location2)]
	
    var body: some View {
		List {
			ForEach(locations, id: \.ckRecordID) { location in
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

