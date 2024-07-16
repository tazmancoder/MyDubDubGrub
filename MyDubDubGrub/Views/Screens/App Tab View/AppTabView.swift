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
			
			NavigationStack { LocationListView() }
				.tabItem { Label(title: { Text("Locations") }, icon: { Image(systemName: "building") }) }
			
			NavigationStack { ProfileView() }
				.tabItem { Label(title: { Text("Profile") }, icon: { Image(systemName: "person") }) }
		}
		.task {
			try? await CloudKitManager.shared.getUserRecord()
			viewModel.checkIfHasSeenOnboard()
		}
		.sheet(isPresented: $viewModel.isShowingOnboardView) {
			OnBoardView()
		}
    }
}

//#Preview {
//    AppTabView()
//}
