//
//  ProfileViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import Foundation
import CloudKit

final class ProfileViewModel: ObservableObject {
	// MARK: - Properties
	@Published var firstName = ""
	@Published var lastName = ""
	@Published var companyName = ""
	@Published var bio = ""
	@Published var avatar = PlaceHolderImage.avatar
	@Published var isShowingPhotoPicker = false
	@Published var alertItem: AlertItem?

	// MARK: - View Functions
	func isValidProfile() -> Bool {
		guard !firstName.isEmpty,
			  !lastName.isEmpty,
			  !companyName.isEmpty,
			  !bio.isEmpty,
			  avatar != PlaceHolderImage.avatar,
			  bio.count <= 100 else { return false }
		return true
	}
	
	func createProfile() {
		guard isValidProfile() else {
			alertItem = AlertContext.invalidProfile
			return
		}
		
		// Create our CKRecord
		let profileRecord = createProfileRecord()
		guard let userRecord = CloudKitManager.shared.userRecord else {
			// Show an alert
			return
		}

		// Create reference on UserRecord to the DDGProfile we created
		userRecord[User.userProfile] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
		
		CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
			switch result {
			case .success(_):
				// Show Alert
				break
			case .failure(_):
				// Show Alert
				break
			}
		}
	}

	func getProfile() {
		guard let userRecord = CloudKitManager.shared.userRecord else {
			// Show an alert
			return
		}
		
		guard let profileReference = userRecord[User.userProfile] as? CKRecord.Reference else {
			// Show Alert
			return
		}
		
		let profileRecordID = profileReference.recordID
		
		CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
			DispatchQueue.main.async { [self] in
				switch result {
				case .success(let record):
					let profile = DDGProfile(record: record)
					
					firstName = profile.firstName
					lastName = profile.lastName
					companyName = profile.companyName
					bio = profile.bio
					avatar = profile.createAvatarImage()
				case .failure(_):
					// Show Alert
					break
				}
			}
		}
	}
	
	private func createProfileRecord() -> CKRecord {
		let profileRecord = CKRecord(recordType: RecordType.profile)
		profileRecord[DDGProfile.kFirstName] = firstName
		profileRecord[DDGProfile.kLastName] = lastName
		profileRecord[DDGProfile.kCompanyName] = companyName
		profileRecord[DDGProfile.kBio] = bio
		profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
		
		return profileRecord
	}
}
