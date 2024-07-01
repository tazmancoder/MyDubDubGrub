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
	
	// MARK: - Profile Data
	
}