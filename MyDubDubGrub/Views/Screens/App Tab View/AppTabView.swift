//
//  AppTabView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct AppTabView: View {
	// MARK: - View Model
	@StateObject var viewModel = AppTabViewModel()
	
    var body: some View {
		TabView {
			LocationMapView()
				.tabItem { Label( title: { Text("Map") }, icon: { Image(systemName: "map") }) }
			
			NavigationView { LocationListView() }
				.tabItem { Label(title: { Text("Locations") }, icon: { Image(systemName: "building") }) }
			
			NavigationView { ProfileView() }
				.tabItem { Label(title: { Text("Profile") }, icon: { Image(systemName: "person") }) }
		}
		.onAppear {
			CloudKitManager.shared.getUserRecord()
			viewModel.runStartUpChecks()
		}
		.accentColor(.brandPrimary)
		.sheet(isPresented: $viewModel.isShowingOnboardView, onDismiss: viewModel.checkIfLocationServicesIsEnabled) {
			OnBoardView()
		}
    }
}

//#Preview {
//    AppTabView()
//}
