//
//  ProfileView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
	// MARK: - State
	@State private var firstName = ""
	@State private var lastName = ""
	@State private var companyName = ""
	@State private var bio = ""
	@State private var avatar = PlaceHolderImage.avatar
	@State private var isShowingPhotoPicker = false
	@State private var alertItem: AlertItem?
	
    var body: some View {
		VStack {
			ZStack {
				NameBackgroundView()
				
				HStack(spacing: 16) {
					ZStack {
						AvatarView(image: avatar, size: 84)
						EditImage()
					}
					.padding(.leading, 12)
					.onTapGesture {
						isShowingPhotoPicker = true
					}

					VStack(spacing: 1) {
						TextField("First Name", text: $firstName)
							.profileNameStyle()
						TextField("Last Name", text: $lastName)
							.profileNameStyle()
						TextField("Company Name", text: $companyName)
					}
					.padding(.trailing, 16)
				}
				.padding()
			}
			
			VStack(alignment: .leading, spacing: 8) {
				CharactersRemainView(currentCount: bio.count)
				TextEditor(text: $bio)
					.frame(height: 100)
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color.secondary, lineWidth: 1.0)
					)
			}
			.padding(.horizontal)
			
			Spacer()
			
			Button {
//				createProfile()
			} label: {
				DDGButton(title: "Create Profile")
			}
			.padding(.bottom)
		}
		.navigationTitle("Profile")
		.toolbar {
			Button {
				dismissKeyboard()
			} label: {
				Image(systemName: "keyboard.chevron.compact.down")
			}
		}
		.onAppear {
			getProfile()
		}
		.alert(item: $alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.sheet(isPresented: $isShowingPhotoPicker) {
			PhotoPicker(image: $avatar)
		}
    }
	
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
		let profileRecord = CKRecord(recordType: RecordType.profile)
		profileRecord[DDGProfile.kFirstName] = firstName
		profileRecord[DDGProfile.kLastName] = lastName
		profileRecord[DDGProfile.kCompanyName] = companyName
		profileRecord[DDGProfile.kBio] = bio
		profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
		
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
					
					DispatchQueue.main.async {
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
}

#Preview {
	NavigationView {
		ProfileView()
	}
}

// MARK: - Sub Views
struct NameBackgroundView: View {
	var body: some View {
		Color(.secondarySystemBackground)
			.frame(height: 130)
			.cornerRadius(12)
			.padding(.horizontal)
	}
}

struct EditImage: View {
	var body: some View {
		Image(systemName: "square.and.pencil")
			.resizable()
			.scaledToFit()
			.frame(width: 14, height: 14)
			.foregroundColor(.white)
			.offset(y: 30)
	}
}

struct CharactersRemainView: View {
	// MARK: - Properties
	var currentCount: Int
	
	var body: some View {
		Text("Bio: ")
			.font(.callout)
			.foregroundColor(.secondary)
		+ Text("\(100 - currentCount)")
			.font(.callout)
			.bold()
			.foregroundColor(currentCount <= 100 ? .brandPrimary : Color(.systemPink))
		+ Text(" Characters Remain")
			.font(.callout)
			.foregroundColor(.secondary)
	}
}
