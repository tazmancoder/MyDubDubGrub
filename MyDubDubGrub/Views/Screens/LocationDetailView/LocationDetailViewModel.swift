//
//  LocationDetailViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/2/24.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

final class LocationDetailViewModel: ObservableObject {
	// MARK: - Published Properties
	@Published var isCheckedIn = false
	@Published var checkedInProfiles: [DDGProfile] = []
	@Published var isShowingProfileModal = false
	@Published var alertItem: AlertItem? = nil

	// MARK: - Grid Items
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	// MARK: - Properties
	var location: DDGLocation
	
	init(location: DDGLocation) {
		self.location = location
	}
	
	// MARK: - Functions
	func getDirectionsToLocation() {
		let placemark = MKPlacemark(coordinate: location.location.coordinate)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = location.name
		
		mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
	}
	
	func callLocation() {
		guard let url = URL(string: "tel://\(location.phoneNumber)") else {
			alertItem = AlertContext.invalidPhoneNumber
			return
		}
		UIApplication.shared.open(url)
	}
	
	func updateCheckInStatus(to checkInStatus: CheckInStatus) {
		// Retrieve the DDGProfile
		guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
		
		// Create a reference to the location
		CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
			switch result {
			case .success(let record):
				// Create a reference to the location
				switch checkInStatus {
				case .checkedIn:
					record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
				case .checkedOut:
					record[DDGProfile.kIsCheckedIn] = nil
				}
				
				// Save the updated profile to CloudKit
				CloudKitManager.shared.save(record: record) { result in
					let profile = DDGProfile(record: record)
					
					DispatchQueue.main.async { [self] in
						switch result {
						case .success(_):
							switch checkInStatus {
							case .checkedIn:
								checkedInProfiles.append(profile)
							case .checkedOut:
								checkedInProfiles.removeAll(where: { $0.id == profile.id })
							}
							
							
							isCheckedIn = checkInStatus == .checkedIn
							
							print("✅ Check In/Out Successful")
						case .failure(_):
							print("❌ Unable to save record")
						}
					}
				}
			case .failure(_):
				print("❌ Error fetching record")
			}
		}
	}
	
	func getCheckedInProfiles() {
		CloudKitManager.shared.getCheckedInProfiles(for: location.id) { result in
			DispatchQueue.main.async { [self] in
				switch result {
				case .success(let profiles):
					checkedInProfiles = profiles
				case .failure(_):
					print("❌ Error fetching checked in profiles")
				}
			}
		}
	}
}
