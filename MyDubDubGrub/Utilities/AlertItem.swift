//
//  AlertItem.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import SwiftUI

struct AlertItem: Identifiable {
	let id = UUID()
	let title: Text
	let message: Text
	let dismissButton: Alert.Button
}

struct AlertContext {
	// MARK: - MapView Errors
	static let unableToGetLocations = AlertItem(
		title: Text("Locations Error"),
		message: Text("Unable to retrieve locations at this time.\nPlease try again."),
		dismissButton: .default(Text("OK"))
	)
}
