//
//  DDGProfile.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import CloudKit
import UIKit

struct DDGProfile {
	// MARK: - Stringly typed constants
	static let kAvatar = "avatar"
	static let kBio = "bio"
	static let kCompanyName = "companyName"
	static let kFirstName = "firstName"
	static let kLastName = "lastName"
	static let kIsCheckedIn = "isCheckedIn"
	
	// MARK: - Properties
	let ckRecordID: CKRecord.ID
	let avatar: CKAsset!
	let bio: String
	let companyName: String
	let firstName: String
	let lastName: String
	let isCheckedIn: CKRecord.Reference? = nil

	init(record: CKRecord) {
		ckRecordID = record.recordID
		avatar = record[DDGProfile.kAvatar] as? CKAsset
		bio = record[DDGProfile.kBio] as? String ?? "N/A"
		companyName = record[DDGProfile.kCompanyName] as? String ?? "N/A"
		firstName = record[DDGProfile.kFirstName] as? String ?? "N/A"
		lastName = record[DDGProfile.kLastName] as? String ?? "N/A"
	}
	
	// MARK: - Functions
	func createAvatarImage() -> UIImage {
		guard let avatar = avatar else { return PlaceHolderImage.square }
		return avatar.convertToUIImage(in: .square)
	}
}
