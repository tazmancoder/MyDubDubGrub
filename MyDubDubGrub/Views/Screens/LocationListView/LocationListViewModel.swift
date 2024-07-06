//
//  LocationListViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import CloudKit
import SwiftUI

final class LocationListViewModel: ObservableObject {
	@Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
	
	func getCheckInProfilesDictionary() {
		CloudKitManager.shared.getCheckedInProfilesDictionary { result in
			DispatchQueue.main.async {
				switch result {
					case .success(let checkedInProfiles):
						self.checkedInProfiles = checkedInProfiles
					case .failure(_):
						print("❌ Error getting back dictionary")
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
	func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View {
		if sizeCategory >= .accessibilityMedium {
			LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
		} else {
			LocationDetailView(viewModel: LocationDetailViewModel(location: location))
		}
	}
}
