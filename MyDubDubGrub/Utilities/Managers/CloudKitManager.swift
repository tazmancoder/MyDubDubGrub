//
//  CloudKitManager.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import CloudKit

final class CloudKitManager {
	// Singleton
	static let shared = CloudKitManager()
	
	// MARK: - Init
	private init() {}
	
	// MARK: - Properties
	var userRecord: CKRecord?
	var profileRecordID: CKRecord.ID?
	let container = CKContainer.default()
	
	// MARK: - Functions
	func getUserRecord() async throws {
		// Get our UserRecordID for the Container
		let recordID = try await container.userRecordID()
		
		// Get UserRecord form the Public Database
		let record = try await container.publicCloudDatabase.record(for: recordID)
		userRecord = record
		
		if let profileReference = record[User.userProfile] as? CKRecord.Reference {
			profileRecordID = profileReference.recordID
		}
	}
	
	
	/// Will go out to iCloud and get all locations
	/// - Parameter completed: Returns an array of DDGLocation
	func getLocations() async throws -> [DDGLocation] {
		let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
		
		// Query the record type and give me all of them
		let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
		query.sortDescriptors = [sortDescriptor]
		
		// This is where we go get the data
		let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query)
		let records = matchedResults.compactMap { _, result in try? result.get() }
		
		// Convert records we get back to [DDGLocation]
		return records.map(DDGLocation.init)
	}
	
	
	func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [DDGProfile] {
		let reference = CKRecord.Reference(recordID: locationID, action: .none)
		let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
		let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
		
		// Now fetch the array of CKRecords that are checked in to the location
		let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query)
		let records = matchedResults.compactMap { _, result in try? result.get() }
		
		return records.map(DDGProfile.init)
	}
	
	
	func getCheckedInProfilesDictionary() async throws -> [CKRecord.ID: [DDGProfile]] {
		
		let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
		let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
		
		var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
		
		// This operation fires off as it receives the records.
		// Build our dictionary of [CKRecord.ID: [DDGProfile]]
		let (matchedResults, cursor) = try await container.publicCloudDatabase.records(matching: query)
		let records = matchedResults.compactMap { _, result in try? result.get() }
		
		for record in records {
			// Create a DDGProfile
			let profile = DDGProfile(record: record)
			
			// Check to make sure we have a reference to a location
			guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
			
			// Now check to see if we have an array with this record id, if not add an empty
			// array otherwise append the profile to that location references recordID.
			checkedInProfiles[locationReference.recordID, default: []].append(profile)
		}
		
		guard let cursor = cursor else { return checkedInProfiles }
		
		do {
			return try await continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
		} catch {
			throw error
		}
	}
	
	
	/// Will continue to fetch records as long as the cursor has a value
	/// - Parameters:
	///   - cursor: position of the next batch of records to fetch
	///   - dictionary: The dictionary we are trying to build
	///   - completed: The return value we get back when done
	private func continueWithCheckedInProfilesDict(cursor: CKQueryOperation.Cursor,
										   dictionary: [CKRecord.ID: [DDGProfile]]) async throws -> [CKRecord.ID: [DDGProfile]] {
		var checkedInProfiles = dictionary
		
		// This operation fires off as it receives the records.
		// Build our dictionary of [CKRecord.ID: [DDGProfile]]
		let (matchedResults, cursor) = try await container.publicCloudDatabase.records(continuingMatchFrom: cursor)
		let records = matchedResults.compactMap { _, result in try? result.get() }
		
		for record in records {
			// Create a DDGProfile
			let profile = DDGProfile(record: record)
			
			// Check to make sure we have a reference to a location
			guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
			
			// Now check to see if we have an array with this record id, if not add an empty
			// array otherwise append the profile to that location references recordID.
			checkedInProfiles[locationReference.recordID, default: []].append(profile)
		}
		
		// Check for cursor
		guard let cursor = cursor else { return checkedInProfiles }
		
		do {
			return try await continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
		} catch {
			throw error
		}
	}
	
	
	func getCheckedInProfilesCount() async throws -> [CKRecord.ID: Int] {
		let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
		let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
		
		var checkedInProfiles: [CKRecord.ID: Int] = [:]
		
		// This operation fires off as it receives the records.
		// Build our dictionary of [CKRecord.ID: [DDGProfile]]
		let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query, desiredKeys: [DDGProfile.kIsCheckedIn])
		let records = matchedResults.compactMap { _, result in try? result.get() }
		
		for record in records {
			// Check to make sure we have a reference to a location
			guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
			
			// Now get the count for each location
			if let count = checkedInProfiles[locationReference.recordID] {
				checkedInProfiles[locationReference.recordID] = count + 1
			} else {
				checkedInProfiles[locationReference.recordID] = 1
			}
		}
		
		return checkedInProfiles
	}

	// MARK: - Convience API Stuff
	func batchSave(records: [CKRecord]) async throws -> [CKRecord] {
		// Get all the records
		let (savedResults, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
		return savedResults.compactMap { _, result in try? result.get() }
	}
	
	func save(record: CKRecord) async throws -> CKRecord {
		return try await container.publicCloudDatabase.save(record)
	}
	
	func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord {
		return try await container.publicCloudDatabase.record(for: id)
	}
}
