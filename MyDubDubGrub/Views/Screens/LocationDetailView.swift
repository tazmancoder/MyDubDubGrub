//
//  LocationDetailView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI
import UIKit

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
			BannerImageView(image: location.createBannerImage())
			
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
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Sean")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Mark")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Kristine")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Mechell")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Jeanne")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Harry")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Devon")
					FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Cheyenne")
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
	var image: UIImage
	
	var body: some View {
		Image(uiImage: image)
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
