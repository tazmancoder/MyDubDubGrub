//
//  Constants.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import Foundation
import UIKit

enum RecordType {
	static let location = "DDGLocation"
	static let profile = "DDGProfile"
}

enum PlaceHolderImages {
	static let avatar = UIImage(named: "default-avatar")!
	static let banner = UIImage(named: "default-banner-asset")!
	static let square = UIImage(named: "default-square-asset")!
}

enum ImageDimension {
	case square, banner
	
	static func getPlaceholder(for dimension: ImageDimension) -> UIImage {
		switch dimension {
		case .square:
			return PlaceHolderImages.square
		case .banner:
			return PlaceHolderImages.banner
		}
	}
}

