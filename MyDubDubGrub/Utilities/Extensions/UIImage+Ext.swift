//
//  UIImage+Ext.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import CloudKit
import UIKit

extension UIImage {
	func convertToCKAsset() -> CKAsset? {
		// Get apps base documents directory
		guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		
		// Append unique identifier for our profile image
		let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
		
		// Write the image data to the location the address points to
		guard let imageData = jpegData(compressionQuality: 0.25) else { return nil }
		
		// Create our CKAsset with that fileURL
		do {
			try imageData.write(to: fileUrl)
			return CKAsset(fileURL: fileUrl)
		} catch {
			return nil
		}
	}
}
