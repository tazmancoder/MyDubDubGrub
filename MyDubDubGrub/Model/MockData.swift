//
//  MockData.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import CloudKit

struct MockData {
	// MARK: - Location Data
	
	static var location: CKRecord {
		let record = CKRecord(recordType: RecordType.location)
		
		record[DDGLocation.kName] = "Sean's Bar and Grill"
		record[DDGLocation.kAddress] = "1334 Main Street, Ste: 12A"
		record[DDGLocation.kDescription] = "Sean's Bar and Grill offers a cozy ambiance with traditional American fare. Enjoy classics like juicy burgers, hearty steaks, and fresh seafood, all accompanied by crisp local beers and handcrafted cocktails. Perfect for a casual lunch, family dinner, or lively night out."
		record[DDGLocation.kWebsiteURL] = "https://apple.com"
		record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
		record[DDGLocation.kPhoneNumber] = "435-241-2518"
		
		return record
	}

	static var location1: CKRecord {
		let record = CKRecord(recordType: RecordType.location)
		
		record[DDGLocation.kName] = "Burger Haven"
		record[DDGLocation.kAddress] = "309 E 100 S"
		record[DDGLocation.kDescription] = "Welcome to Burger Haven, where we specialize in crafting the juiciest burgers and crispiest fries. Enjoy a variety of gourmet burgers made with premium ingredients, all paired with golden, perfectly seasoned fries. Simple, delicious, and satisfying—every time."
		record[DDGLocation.kWebsiteURL] = "https://apple.com"
		record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
		record[DDGLocation.kPhoneNumber] = "435-882-1008"
		
		return record
	}

	static var location2: CKRecord {
		let record = CKRecord(recordType: RecordType.location)
		
		record[DDGLocation.kName] = "A Taste of the Ocean"
		record[DDGLocation.kAddress] = "470 Water Wheel Lane"
		record[DDGLocation.kDescription] = "Dive into Ocean's Delight, where we serve the freshest seafood daily. Savor succulent lobster, mouthwatering shrimp, and perfectly grilled fish. Every dish is a coastal masterpiece, paired with ocean views and a relaxed atmosphere. Experience the sea's bounty like never before."
		record[DDGLocation.kWebsiteURL] = "https://apple.com"
		record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
		record[DDGLocation.kPhoneNumber] = "928-778-2138"
		
		return record
	}
	
	static var chipotle: CKRecord {
		let record                          = CKRecord(recordType: RecordType.location,
													   recordID: CKRecord.ID(recordName: "0AF6129C-922E-4525-B590-F4575B8A41D9"))
		record[DDGLocation.kName]           = "Chipotle"
		record[DDGLocation.kAddress]        = "1 S Market St Ste 40"
		record[DDGLocation.kDescription]    = "Our local San Jose One South Market Chipotle Mexican Grill is cultivating a better world by serving responsibly sourced, classically-cooked, real food."
		record[DDGLocation.kWebsiteURL]     = "https://locations.chipotle.com/ca/san-jose/1-s-market-st"
		record[DDGLocation.kLocation]       = CLLocation(latitude: 37.334967, longitude: -121.892566)
		record[DDGLocation.kPhoneNumber]    = "408-938-0919"
		
		return record
	}
	
	// MARK: - Profile Data
	static var profile: CKRecord {
		let record = CKRecord(recordType: RecordType.profile)
		
		record[DDGProfile.kAvatar] = PlaceHolderImage.avatar.convertToCKAsset()
		record[DDGProfile.kBio] = "Indie iOS developer crafting unique and innovative productivity apps for enhanced efficiency."
		record[DDGProfile.kCompanyName] = "Apple Enthusiast & Indie Dev"
		record[DDGProfile.kFirstName] = "Mark"
		record[DDGProfile.kLastName] = "Perryman"
		record[DDGProfile.kIsCheckedIn] = nil
		
		return record
	}

}
