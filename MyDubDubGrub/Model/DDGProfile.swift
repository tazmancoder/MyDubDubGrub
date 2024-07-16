//
//  DDGProfile.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import CloudKit
import UIKit

struct DDGProfile: Identifiable {
	// MARK: - Stringly typed constants
	static let kAvatar = "avatar"
	static let kBio = "bio"
	static let kCompanyName = "companyName"
	static let kFirstName = "firstName"
	static let kLastName = "lastName"
	static let kIsCheckedIn = "isCheckedIn"
	static let kIsCheckedInNilCheck = "isCheckedInNilCheck"
	
	// MARK: - Properties
	let id: CKRecord.ID
	let avatar: CKAsset!
	let bio: String
	let companyName: String
	let firstName: String
	let lastName: String
	
	init(record: CKRecord) {
		id = record.recordID
		avatar = record[DDGProfile.kAvatar] as? CKAsset
		bio = record[DDGProfile.kBio] as? String ?? "N/A"
		companyName = record[DDGProfile.kCompanyName] as? String ?? "N/A"
		firstName = record[DDGProfile.kFirstName] as? String ?? "N/A"
		lastName = record[DDGProfile.kLastName] as? String ?? "N/A"
	}
	
	// MARK: - Functions
	var avatarImage: UIImage {
		guard let avatar else { return PlaceHolderImage.avatar }
		return avatar.convertToUIImage(in: .square)
	}
}
