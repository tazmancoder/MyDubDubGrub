//
//  CKRecord+Ext.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import CloudKit

extension CKRecord {
	func convertToDDGLocation() -> DDGLocation { DDGLocation(record: self) }
	func convertToDDGProfile() -> DDGProfile { DDGProfile(record: self) }
}
