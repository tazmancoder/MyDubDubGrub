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
	
	// MARK: - Functions
	func getUserRecord() {
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
				
				self.userRecord = userRecord
				if let profileReference = userRecord[User.userProfile] as? CKRecord.Reference {
					self.profileRecordID = profileReference.recordID
				}
			}
		}
	}
	
	/// Will go out to iCloud and get all locations
	/// - Parameter completed: Returns an array of DDGLocation
	func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
		let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
		
		// Query the record type and give me all of them
		let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
		query.sortDescriptors = [sortDescriptor]
		
		// This is where we go get the data
		CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
			// Check to make sure error isn't nil otherwise fail
			guard error == nil else {
				completed(.failure(error!))
				return
			}
			
			// Check to make sure we have records
			guard let records = records else { return }
			
			// Convert records we get back to [DDGLocation]
			let locations = records.map { $0.convertToDDGLocation() }
			completed(.success(locations))
		}
	}
	
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
