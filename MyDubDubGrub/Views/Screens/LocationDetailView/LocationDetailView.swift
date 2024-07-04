//
//  LocationDetailView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI
import UIKit

struct LocationDetailView: View {
	@ObservedObject var viewModel: LocationDetailViewModel
	
    var body: some View {
		ZStack {
			VStack(spacing: 16) {
				BannerImageView(image: viewModel.location.createBannerImage())
				
				// Location Address
				HStack {
					AddressView(address: viewModel.location.address)
					Spacer()
				}
				.padding(.horizontal)
				
				// Location Description
				DescriptionView(text: viewModel.location.description)
				
				// List of action buttons
				ZStack {
					Capsule()
						.frame(height: 80)
						.foregroundColor(Color(.secondarySystemBackground))
					
					HStack(spacing: 20) {
						Button {
							viewModel.getDirectionsToLocation()
						} label: {
							LocationActionButton(imageColor: .brandPrimary, imageName: "location.fill")
						}
						
						Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
							LocationActionButton(imageColor: .brandPrimary, imageName: "network")
						})
						
						Button {
							viewModel.callLocation()
						} label: {
							LocationActionButton(imageColor: .brandPrimary, imageName: "phone.fill")
						}
						
						Button {
							viewModel.updateCheckInStatus(to: .checkedOut)
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
					LazyVGrid(columns: viewModel.columns, content: {
						FirstNameAvatarView(image: PlaceHolderImage.avatar, firstName: "Sean")
							.onTapGesture {
								viewModel.isShowingProfileModal = true
							}
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
			
			if viewModel.isShowingProfileModal {
				Color(.systemBackground)
					.ignoresSafeArea()
					.opacity(0.9)
//					.transition(.opacity)
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
					.animation(.easeOut)
					.zIndex(1)
				
				ProfileModalView(profile: DDGProfile(record: MockData.profile), isShowingProfileModal: $viewModel.isShowingProfileModal)
					.transition(.opacity.combined(with: .slide))
					.animation(.easeOut)
					.zIndex(2)
			}
		}
		.alert(item: $viewModel.alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.navigationTitle(viewModel.location.name)
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
	LocationDetailView(
		viewModel: LocationDetailViewModel(
			location: DDGLocation(record: MockData.location)
		)
	)
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
