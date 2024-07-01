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
			  bio.count < 100 else { return false }
		return true
	}
	
	func createProfile() {
		guard isValidProfile() else {
			alertItem = AlertContext.invalidProfile
			return
		}
		
		// Create our CKRecord
		let profileRecord = createProfileRecord()
		
		// Get our UserRecordID for the Container
		CKContainer.default().fetchUserRecordID { recordID, error in
			// Unwrap the recordID, make sure it has something in it
			guard let recordID = recordID, error == nil else {
				print(error!.localizedDescription)
				return
			}
			
			// Get UserRecord form the Public Database
			CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
				// Making sure userRecord has something in it
				guard let userRecord = userRecord, error == nil else {
					print(error!.localizedDescription)
					return
				}
				
				// Create reference on UserRecord to the DDGProfile we created
				userRecord[User.userProfile] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
				
				// Create CKOperation to save our User and Profile Records
				let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
				operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
					// Make sure we have savedRecords
					guard let savedRecords = savedRecords, error == nil else {
						print(error!.localizedDescription)
						return
					}
					
					print(savedRecords)
				}
				
				// Adding the operation to send all these records to the cloud
				CKContainer.default().publicCloudDatabase.add(operation)
			}
		}
	}

	func getProfile() {
		// Get our UserRecordID for the Container
		CKContainer.default().fetchUserRecordID { recordID, error in
			// Unwrap the recordID, make sure it has something in it
			guard let recordID = recordID, error == nil else {
				print(error!.localizedDescription)
				return
			}
			
			// Get UserRecord form the Public Database
			CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
				// Making sure userRecord has something in it
				guard let userRecord = userRecord, error == nil else {
					print(error!.localizedDescription)
					return
				}
				
				let profileReference = userRecord[User.userProfile] as! CKRecord.Reference
				let profileRecordID = profileReference.recordID
				
				CKContainer.default().publicCloudDatabase.fetch(withRecordID: profileRecordID) { profileRecord, error in
					guard let profileRecord = profileRecord, error == nil else {
						print(error!.localizedDescription)
						return
					}
					
					DispatchQueue.main.async { [self] in
						let profile = DDGProfile(record: profileRecord)
						
						firstName = profile.firstName
						lastName = profile.lastName
						companyName = profile.companyName
						bio = profile.bio
						avatar = profile.createAvatarImage()
					}
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
