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
	
	func getCheckedInProfilesDictionary(completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void) {
		let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
		let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
		let operation = CKQueryOperation(query: query)
		
		// This is how you could limit the scope of what you actual download from CloudKit
//		operation.desiredKeys = [DDGProfile.kIsCheckedIn, DDGProfile.kAvatar]
		
		var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
		
		// This operation fires off as it receives the records.
		// Build our dictionary of [CKRecord.ID: [DDGProfile]]
		operation.recordFetchedBlock = { record in
			// Create a DDGProfile
			let profile = DDGProfile(record: record)
			
			// Check to make sure we have a reference to a location
			guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
			
			// Now check to see if we have an array with this record id, if not add an empty
			// array otherwise append the profile to that location references recordID.
			checkedInProfiles[locationReference.recordID, default: []].append(profile)
		}
		
		// When everything is done and we've downloaded all records
		operation.queryCompletionBlock = { cursor, error in
			// WHAT IS THE CURSOR?
			// The cursor above represents you place in the list of all the records your downloading
			// Basically if you've got a 1000 records to download and CloudKit determines it can
			// return 100 records to you, then the cursor will be set at record 101 and when it down-
			// loads again it will pick up at record 101 and download whatever limit it can at that
			// time and then reset the cursor to that place in line.
			
			guard error == nil else {
				completed(.failure(error!))
				return
			}
			
			if let cursor = cursor {
				self.continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles) { result in
					switch result {
						case .success(let profiles):
							completed(.success(profiles))
						case .failure(let error):
							completed(.failure(error))
					}
				}
			} else {
				completed(.success(checkedInProfiles))
			}
		}
		
		// Now add the operation so that it will fire off
		CKContainer.default().publicCloudDatabase.add(operation)
	}
	
	
	/// Will continue to fetch records as long as the cursor has a value
	/// - Parameters:
	///   - cursor: position of the next batch of records to fetch
	///   - dictionary: The dictionary we are trying to build
	///   - completed: The return value we get back when done
	func continueWithCheckedInProfilesDict(cursor: CKQueryOperation.Cursor,
										   dictionary: [CKRecord.ID: [DDGProfile]],
										   completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void) {
		var checkedInProfiles = dictionary
		let operation = CKQueryOperation(cursor: cursor)
		
		// This operation fires off as it receives the records.
		// Build our dictionary of [CKRecord.ID: [DDGProfile]]
		operation.recordFetchedBlock = { record in
			// Create a DDGProfile
			let profile = DDGProfile(record: record)
			
			// Check to make sure we have a reference to a location
			guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
			
			// Now check to see if we have an array with this record id, if not add an empty
			// array otherwise append the profile to that location references recordID.
			checkedInProfiles[locationReference.recordID, default: []].append(profile)
		}
		
		// When everything is done and we've downloaded all records
		operation.queryCompletionBlock = { cursor, error in
			// WHAT IS THE CURSOR?
			// The cursor above represents you place in the list of all the records your downloading
			// Basically if you've got a 1000 records to download and CloudKit determines it can
			// return 100 records to you, then the cursor will be set at record 101 and when it down-
			// loads again it will pick up at record 101 and download whatever limit it can at that
			// time and then reset the cursor to that place in line.
			guard error == nil else {
				completed(.failure(error!))
				return
			}

			// Nil check on cursor
			if let cursor = cursor {
				self.continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles) { result in
					switch result {
						case .success(let profiles):
							completed(.success(profiles))
						case .failure(let error):
							completed(.failure(error))
					}
				}
			} else {
				completed(.success(checkedInProfiles))
			}
		}
		
		// Now add the operation so that it will fire off
		CKContainer.default().publicCloudDatabase.add(operation)
	}
	
	
	func getCheckedInProfilesCount(completed: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void) {
		let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
		let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
		let operation = CKQueryOperation(query: query)
		// This is how you could limit the scope of what you actual download from CloudKit
		operation.desiredKeys = [DDGProfile.kIsCheckedIn]
		
		var checkedInProfiles: [CKRecord.ID: Int] = [:]
		
		// This operation fires off has it receives the records.
		// Build our dictionary of [CKRecord.ID: [DDGProfile]]
		operation.recordFetchedBlock = { record in
			// Check to make sure we have a reference to a location
			guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
			
			// Now get the count for each location
			if let count = checkedInProfiles[locationReference.recordID] {
				checkedInProfiles[locationReference.recordID] = count + 1
			} else {
				checkedInProfiles[locationReference.recordID] = 1
			}
		}
		
		// When everything is done and we've downloaded all records
		operation.queryCompletionBlock = { cursor, error in
			// WHAT IS THE CURSOR?
			// The cursor above represents you place in the list of all the records your downloading
			// Basically if you've got a 1000 records to download and CloudKit determines it can
			// return 100 records to you, then the cursor will be set at record 101 and when it down-
			// loads again it will pick up at record 101 and download whatever limit it can at that
			// time and then reset the cursor to that place in line.
			
			guard error == nil else {
				completed(.failure(error!))
				return
			}
			
			// Handle the cursor in later video
			completed(.success(checkedInProfiles))
		}
		
		// Now add the operation so that it will fire off
		CKContainer.default().publicCloudDatabase.add(operation)
	}

	// MARK: - Convience API Stuff
	func batchSave(records: [CKRecord], completed: @escaping (Result<[CKRecord], Error>) -> Void) {
		// Create CKOperation to save our User and Profile Records
		let operation = CKModifyRecordsOperation(recordsToSave: records)
		operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
			// Make sure we have savedRecords
			guard let savedRecords = savedRecords, error == nil else {
				completed(.failure(error!))
				return
			}
			
			completed(.success(savedRecords))
		}
		
		// Adding the operation to send all these records to the cloud
		CKContainer.default().publicCloudDatabase.add(operation)
	}
	
	func save(record: CKRecord, completed:  @escaping (Result<CKRecord, Error>) -> Void) {
		CKContainer.default().publicCloudDatabase.save(record) { record, error in
			guard let record = record, error == nil else {
				print(error!.localizedDescription)
				completed(.failure(error!))
				return
			}
			
			completed(.success(record))
		}
	}
	
	func fetchRecord(with id: CKRecord.ID, completed:  @escaping (Result<CKRecord, Error>) -> Void) {
		CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
			guard let record = record, error == nil else {
				print(error!.localizedDescription)
				completed(.failure(error!))
				return
			}
			
			completed(.success(record))
		}
	}
}
