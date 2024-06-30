//
//  CloudKitManager.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import CloudKit

struct CloudKitManager {
	
	/// Will go out to iCloud and get all locations
	/// - Parameter completed: Returns an array of DDGLocation
	static func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
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
}
