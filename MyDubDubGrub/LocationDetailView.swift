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
	
    var body: some View {
		NavigationView {
			VStack(spacing: 16) {
				Image(.defaultBannerAsset)
					.resizable()
					.scaledToFill()
					.frame(height: 120)
				
				// Location Address
				HStack {
					Label("123 Main Street", systemImage: "mappin.and.ellipse")
						.font(.caption)
						.foregroundColor(.secondary)
					
					Spacer()
				}
				.padding(.horizontal)
				
				// Location Description
				Text("Craving authentic South of the Border flavors? Our restaurant specializes in delicious tacos, burritos, and a variety of other Mexican-inspired dishes. Come in and treat yourself to a culinary fiesta!")
					.lineLimit(4)
					.multilineTextAlignment(.leading)
					.minimumScaleFactor(0.75)
					.padding(.horizontal)
				
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
						
						Link(destination: URL(string: "https://www.apple.com")!, label: {
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
				})
				
				Spacer()
			}
			.navigationTitle("Location Name")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
}

#Preview {
    LocationDetailView()
}