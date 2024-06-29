//
//  AppTabView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
		TabView {
			LocationMapView()
				.tabItem {
					Label(
						title: { Text("Map") },
						icon: { Image(systemName: "map") }
					)
				}
			LocationListView()
				.tabItem {
					Label(
						title: { Text("Locations") },
						icon: { Image(systemName: "building") }
					)
				}
			ProfileView()
				.tabItem {
					Label(
						title: { Text("Profile") },
						icon: { Image(systemName: "person") }
					)
				}
		}
		.accentColor(.brandPrimary)
    }
}

#Preview {
    AppTabView()
}
