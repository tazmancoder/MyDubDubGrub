//
//  LocationListViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import CloudKit
import SwiftUI

extension LocationListView {
	
	@MainActor final class LocationListViewModel: ObservableObject {
		@Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
		@Published var alertItem: AlertItem?
		
		func getCheckInProfilesDictionary() {
			CloudKitManager.shared.getCheckedInProfilesDictionary { result in
				DispatchQueue.main.async { [self] in
					switch result {
						case .success(let checkedInProfiles):
							self.checkedInProfiles = checkedInProfiles
						case .failure(_):
							alertItem = AlertContext.unableToAllGetCheckedInProfiles
					}
				}
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
