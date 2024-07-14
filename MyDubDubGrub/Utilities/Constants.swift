//
//  Constants.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import Foundation
import UIKit

enum Bio {
	static let totalCharacter = 150
}

enum User {
	static let userProfile = "userProfile"
}

enum RecordType {
	static let location = "DDGLocation"
	static let profile = "DDGProfile"
}

enum PlaceHolderImage {
	static let avatar = UIImage(named: "default-avatar")!
	static let banner = UIImage(named: "default-banner-asset")!
	static let square = UIImage(named: "default-square-asset")!
}

enum ImageDimension {
	case square, banner
	
	var placeholder: UIImage {
		switch self {
		case .square:
			return PlaceHolderImage.square
		case .banner:
			return PlaceHolderImage.banner
		}
	}
}

// * Here is the code sample to copy/paste
// * This is an older version we start with and adjust in the video

enum DeviceTypes {
	enum ScreenSize {
		static let width                = UIScreen.main.bounds.size.width
		static let height               = UIScreen.main.bounds.size.height
		static let maxLength            = max(ScreenSize.width, ScreenSize.height)
	}
	
	static let idiom                    = UIDevice.current.userInterfaceIdiom
	static let nativeScale              = UIScreen.main.nativeScale
	static let scale                    = UIScreen.main.scale
	
	static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
}

