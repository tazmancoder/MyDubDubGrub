//
//  ProfileViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import Foundation
import CloudKit

enum ProfileContext { case create, update }

extension ProfileView {
	
	@MainActor final class ProfileViewModel: ObservableObject {
		// MARK: - Properties
		@Published var firstName 			= ""
		@Published var lastName 			= ""
		@Published var companyName 			= ""
		@Published var bio 					= ""
		@Published var avatar 				= PlaceHolderImage.avatar
		@Published var isShowingPhotoPicker = false
		@Published var isLoading 			= false
		@Published var isCheckedIn 			= false
		@Published var alertItem: AlertItem?
		
		private var existingProfileRecord: CKRecord? {
			didSet { profileContext = .update }
		}
		
		var profileContext: ProfileContext = .create
		var buttonTitle: String { profileContext == .create ? "Create Profile" : "Update Profile" }
		
		// MARK: - Public Functions
		func getCheckedInStatus() {
			// Retrieve the DDGProfile
			guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
			
			Task {
				do {
					let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
					if let _ = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
						isCheckedIn = true
					} else {
						isCheckedIn = false
					}
				} catch {
					print("Unable to get checked in status")
				}
			}
		}
		
		
		func checkOut() {
			// Retrieve the DDGProfile
			guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
				alertItem = AlertContext.unableToGetProfile
				return
			}
			
			showLoadingView()
			
			Task {
				do {
					// Get the record
					let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
					record[DDGProfile.kIsCheckedIn] = nil
					record[DDGProfile.kIsCheckedInNilCheck] = nil
					
					// Save the record
					let _ = try await CloudKitManager.shared.save(record: record)
					HapticManager.playSuccess()
					isCheckedIn = false
					
					hideLoadingView()
				} catch {
					hideLoadingView()
					alertItem = AlertContext.unableToCheckInOrOut
				}
			}
		}
		
		
		func determineButtonAction() {
			profileContext == .create ? createProfile() : updateProfile()
		}
		
		
		func getProfile() {
			guard let userRecord = CloudKitManager.shared.userRecord else {
				alertItem = AlertContext.noUserRecord
				return
			}
			
			guard let profileReference = userRecord[User.userProfile] as? CKRecord.Reference else { return }
			let profileRecordID = profileReference.recordID
			
			showLoadingView()
			
			Task {
				do {
					let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
					// Store away the record we get back so we can edit it later
					existingProfileRecord = record
					
					// Convert record into DDGProfile so we can assign the properties
					// to show the user
					let profile = DDGProfile(record: record)
					
					firstName = profile.firstName
					lastName = profile.lastName
					companyName = profile.companyName
					bio = profile.bio
					avatar = profile.avatarImage

					hideLoadingView()
				} catch {
					hideLoadingView()
					alertItem = AlertContext.unableToGetProfile
				}
			}
//			
//			CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
//				DispatchQueue.main.async { [self] in
//					hideLoadingView()
//					
//					switch result {
//						case .success(let record):
//							// Store away the record we get back so we can edit it later
//							existingProfileRecord = record
//							
//							// Convert record into DDGProfile so we can assign the properties
//							// to show the user
//							let profile = DDGProfile(record: record)
//							
//							firstName = profile.firstName
//							lastName = profile.lastName
//							companyName = profile.companyName
//							bio = profile.bio
//							avatar = profile.avatarImage
//							
//						case .failure(_):
//							alertItem = AlertContext.unableToGetProfile
//							break
//					}
//				}
//			}
		}
		
		// MARK: - Private Functions
		private func createProfile() {
			guard isValidProfile() else {
				alertItem = AlertContext.invalidProfile
				return
			}
			
			// Create our CKRecord
			let profileRecord = createProfileRecord()
			guard let userRecord = CloudKitManager.shared.userRecord else {
				alertItem = AlertContext.noUserRecord
				return
			}
			
			// Create reference on UserRecord to the DDGProfile we created
			userRecord[User.userProfile] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
			
			showLoadingView()
			Task {
				do {
					let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
					for record in records where record.recordType == RecordType.profile {
						existingProfileRecord = record
						CloudKitManager.shared.profileRecordID = record.recordID
					}
					hideLoadingView()
					alertItem = AlertContext.createProfileSuccess
				} catch {
					hideLoadingView()
					alertItem = AlertContext.createProfileFailure
				}
			}
		}


		private func updateProfile() {
			guard isValidProfile() else {
				alertItem = AlertContext.invalidProfile
				return
			}
			
			guard let existingProfileRecord else {
				alertItem = AlertContext.unableToGetProfile
				return
			}
			
			existingProfileRecord[DDGProfile.kFirstName] = firstName
			existingProfileRecord[DDGProfile.kLastName] = lastName
			existingProfileRecord[DDGProfile.kCompanyName] = companyName
			existingProfileRecord[DDGProfile.kBio] = bio
			existingProfileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
			
			showLoadingView()
			Task {
				do {
					let _ = try await CloudKitManager.shared.save(record: existingProfileRecord)
					alertItem = AlertContext.updateProfileSuccess
					hideLoadingView()
				} catch {
					hideLoadingView()
					alertItem = AlertContext.unableToUpdateProfile
				}
			}
		}


		private func isValidProfile() -> Bool {
			guard !firstName.isEmpty,
				  !lastName.isEmpty,
				  !companyName.isEmpty,
				  !bio.isEmpty,
				  avatar != PlaceHolderImage.avatar,
				  bio.count <= Bio.totalCharacter else { return false }
			return true
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
		
		private func showLoadingView() { isLoading = true }
		private func hideLoadingView() { isLoading = false }
	}
}
