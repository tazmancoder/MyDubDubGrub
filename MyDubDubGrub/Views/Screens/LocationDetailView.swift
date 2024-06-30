//
//  LocationDetailView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationDetailView: View {
	// MARK: - Grid Items
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	// MARK: - Properties
	var location: DDGLocation
	
    var body: some View {
		VStack(spacing: 16) {
			BannerImageView(imageName: "default-banner-asset")
			
			// Location Address
			HStack {
				AddressView(address: location.address)
				Spacer()
			}
			.padding(.horizontal)
			
			// Location Description
			DescriptionView(text: location.description)
			
			// List of action buttons
			ZStack {
				Capsule()
					.frame(height: 80)
					.foregroundColor(Color(.secondarySystemBackground))
				
				HStack(spacing: 20) {
					Button {
						
					} label: {
						LocationActionButton(imageColor: .brandPrimary, imageName: "location.fill")
					}
					
					Link(destination: URL(string: location.websiteURL)!, label: {
						LocationActionButton(imageColor: .brandPrimary, imageName: "network")
					})
					
					Button {
						
					} label: {
						LocationActionButton(imageColor: .brandPrimary, imageName: "phone.fill")
					}
					
					Button {
						
					} label: {
						LocationActionButton(imageColor: .brandPrimary, imageName: "person.fill.checkmark")
					}
				}
			}
			.padding(.horizontal)
			
			
			// Who's at this location
			Text("Who's Here")
				.bold()
				.font(.title2)
			
			ScrollView(showsIndicators: false) {
				LazyVGrid(columns: columns, content: {
					FirstNameAvatarView(firstName: "Sean")
					FirstNameAvatarView(firstName: "Mark")
					FirstNameAvatarView(firstName: "Kristine")
					FirstNameAvatarView(firstName: "Mechell")
					FirstNameAvatarView(firstName: "Jeanne")
					FirstNameAvatarView(firstName: "Harry")
					FirstNameAvatarView(firstName: "Devon")
					FirstNameAvatarView(firstName: "Cheyenne")
					FirstNameAvatarView(firstName: "Steve")
					FirstNameAvatarView(firstName: "Bob")
					FirstNameAvatarView(firstName: "Thomas")
					FirstNameAvatarView(firstName: "Jackie")
					FirstNameAvatarView(firstName: "Phillip")
				})
			}
			
			Spacer()
		}
		.navigationTitle(location.name)
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
	LocationDetailView(location: DDGLocation(record: MockData.location))
}

// MARK: - Sub Views
struct BannerImageView: View {
	// MARK: - Properties
	var imageName: String
	
	var body: some View {
		Image(imageName)
			.resizable()
			.scaledToFill()
			.frame(height: 120)
	}
}

struct AddressView: View {
	// MARK: - Properites
	var address: String
	
	var body: some View {
		Label(address, systemImage: "mappin.and.ellipse")
			.font(.caption)
			.foregroundColor(.secondary)
	}
}

struct DescriptionView: View {
	// MARK: - Properties
	var text: String
	
	var body: some View {
		Text(text)
			.lineLimit(4)
			.minimumScaleFactor(0.75)
			.multilineTextAlignment(.leading)
			.frame(height: 70)
			.padding(.horizontal)
	}
}
