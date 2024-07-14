//
//  HapticManager.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/14/24.
//

import Foundation
import UIKit

struct HapticManager {
	static func playSuccess() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
	}
}
