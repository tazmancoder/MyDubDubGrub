//
//  LocationListView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
		List {
			ForEach(0..<10) { item in
				NavigationLink(destination: LocationDetailView()) {
					LocationCell()
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

