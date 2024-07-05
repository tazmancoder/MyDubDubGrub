//
//  View+Ext.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

extension View {
	func profileNameStyle() -> some View {
		self.modifier(ProfileNameText())
	}
	
	func playHaptic() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
	}
	
	func dismissKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
