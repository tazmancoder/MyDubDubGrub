//
//  LocationListViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import CloudKit

final class LocationListViewModel: ObservableObject {
	@Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
	
	func getCheckInProfilesDictionary() {
		CloudKitManager.shared.getCheckedInProfilesDictionary { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let checkedInProfiles):
					self.checkedInProfiles = checkedInProfiles
					print(checkedInProfiles)
				case .failure(_):
					print("❌ Error getting back dictionary")
				}
			}
		}
	}
}
