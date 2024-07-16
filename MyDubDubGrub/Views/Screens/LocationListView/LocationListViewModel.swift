//
//  LocationListViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import CloudKit
import SwiftUI
import Observation

extension LocationListView {
	
	@Observable
	@MainActor final class LocationListViewModel {
		var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
		var alertItem: AlertItem?
		
		func getCheckInProfilesDictionary() async {
			do {
				checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
			} catch {
				alertItem = AlertContext.unableToAllGetCheckedInProfiles
			}
		}
		
		
		func createVoiceOverSummary(for location: DDGLocation) -> String {
			let count = checkedInProfiles[location.id, default: []].count
			let personPlurality = count == 1 ? "Person" : "People"
			
			return "\(location.name) \(count) \(personPlurality) checked in."
		}
		
		
		@ViewBuilder
		func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
			if dynamicTypeSize >= .accessibility3 {
				LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
			} else {
				LocationDetailView(viewModel: LocationDetailViewModel(location: location))
			}
		}
	}
}
