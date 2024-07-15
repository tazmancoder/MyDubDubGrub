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
	
	// MARK: - Computed Property
	var alert: Alert {
		Alert(title: title, message: message, dismissButton: dismissButton)
	}
}

struct AlertContext {
	// MARK: - MapView Errors
	static let unableToGetLocations = AlertItem(
		title: Text("Location Retrieval Failed"),
		message: Text("We couldn't fetch your locations at the moment. Please check your connection and try again."),
		dismissButton: .default(Text("OK"))
	)
	
	static let locationRestricted = AlertItem(
		title: Text("Location Access Restricted"),
		message: Text("Your location access is restricted, possibly due to parental controls or device settings."),
		dismissButton: .default(Text("OK"))
	)
	
	static let locationDenied = AlertItem(
		title: Text("Location Access Denied"),
		message: Text("Dub Dub Grub cannot access your location. Please enable location access in Settings > Dub Dub Grub > Location."),
		dismissButton: .default(Text("OK"))
	)
	
	static let locationDisabled = AlertItem(
		title: Text("Location Services Disabled"),
		message: Text("Location services are turned off on your phone. Please enable them in Settings > Privacy > Location Services."),
		dismissButton: .default(Text("OK"))
	)

	static let locationNotFound = AlertItem(
		title: Text("Location Not Found"),
		message: Text("Location was not found or retrieved. Please try again later."),
		dismissButton: .default(Text("OK"))
	)

	static let didFailToGetLocation = AlertItem(
		title: Text("Location Failed"),
		message: Text("Location services was unable to retrieve your current location. Please try again later."),
		dismissButton: .default(Text("OK"))
	)

	static let checkedInCount = AlertItem(
		title: Text("Server Error"),
		message: Text("Unable to get the number of people checked into each location. Please check your internet connection and try again."),
		dismissButton: .default(Text("OK"))
	)
	
	// MARK: - LocationListView Errors
	static let unableToAllGetCheckedInProfiles = AlertItem(
		title: Text("Server Error"),
		message: Text("We are unable to get users checked into this location at this time.\nPlease try again."),
		dismissButton: .default(Text("OK"))
	)

	// MARK: - ProfileView Errors
	static let invalidProfile = AlertItem(
		title: Text("Profile Incomplete"),
		message: Text("Please fill in all fields, including a profile photo, and ensure your bio is under \(Bio.totalCharacter) characters."),
		dismissButton: .default(Text("OK"))
	)
	
	static let noUserRecord = AlertItem(
		title: Text("iCloud Login Required"),
		message: Text("To use Dub Dub Grub's Profile feature, please log in to iCloud in your phone's settings."),
		dismissButton: .default(Text("OK"))
	)
	
	static let createProfileSuccess = AlertItem(
		title: Text("Profile Created!"),
		message: Text("Your profile was created successfully."),
		dismissButton: .default(Text("OK"))
	)
	
	static let createProfileFailure = AlertItem(
		title: Text("Profile Creation Failed"),
		message: Text("We couldn't create your profile. Please try again later or contact customer support if the issue persists."),
		dismissButton: .default(Text("OK"))
	)
	
	static let unableToGetProfile = AlertItem(
		title: Text("Profile Retrieval Failed"),
		message: Text("We couldn't retrieve your profile. Please try again later or contact customer support if the issue persists."),
		dismissButton: .default(Text("OK"))
	)
	
	static let updateProfileSuccess = AlertItem(
		title: Text("Profile Updated!"),
		message: Text("Your profile was updated successfully."),
		dismissButton: .default(Text("OK"))
	)
	
	static let unableToUpdateProfile = AlertItem(
		title: Text("Profile Update Failed"),
		message: Text("We couldn't update your profile. Please try again later or contact customer support if the issue persists."),
		dismissButton: .default(Text("OK"))
	)
	
	// MARK: - LocationDetailView Errors
	static let invalidPhoneNumber = AlertItem(
		title: Text("Invalid Phone Number"),
		message: Text("The phone number entered is incorrect. Please correct it before calling this location."),
		dismissButton: .default(Text("OK"))
	)

	static let unableToGetCheckInStatus = AlertItem(
		title: Text("Server Error"),
		message: Text("Unable to retieve checked in status of the current user.\nPlease try again."),
		dismissButton: .default(Text("OK"))
	)

	static let unableToCheckInOrOut = AlertItem(
		title: Text("Server Error"),
		message: Text("We are unable to check in or out of this location at this time.\nPlease try again."),
		dismissButton: .default(Text("OK"))
	)
	
	static let unableToGetCheckedInProfiles = AlertItem(
		title: Text("Server Error"),
		message: Text("We are unable to get users checked into this location at this time.\nPlease try again."),
		dismissButton: .default(Text("OK"))
	)
}
