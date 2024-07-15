//
//  LocationDetailView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI
import UIKit

struct LocationDetailView: View {
	// MARK: - Environment
	@Environment(\.sizeCategory) var sizeCategory
	
	// MARK: - Properties
	@ObservedObject var viewModel: LocationDetailViewModel
	
	var body: some View {
		ZStack {
			VStack(spacing: 16) {
				BannerImageView(image: viewModel.location.bannerImage)
				
				// Location Address
				AddressHStack(address: viewModel.location.address)
				
				// Location Description
				DescriptionView(text: viewModel.location.description)
				
				// List of action buttons
				ActionButtonHStack(viewModel: viewModel)
				
				// Who's at this location
				GridHeaderTextView(number: viewModel.checkedInProfiles.count)
				
				// Shows the list of Avatars checked into this location
				AvatarGridView(viewModel: viewModel)
				
				// This just pushes everything to the top
				Spacer()
			}
			.accessibilityHidden(viewModel.isShowingProfileModal)

			if viewModel.isShowingProfileModal {
				FullScreenBlackTransparencyView()
				
				ProfileModalView(profile: viewModel.selectedProfile!, isShowingProfileModal: $viewModel.isShowingProfileModal)
			}
		}
		.onAppear {
			viewModel.getCheckedInProfiles()
			viewModel.getCheckedInStatus()
		}
		.sheet(isPresented: $viewModel.isShowingProfileSheet) {
			NavigationView {
				ProfileSheetView(profile: viewModel.selectedProfile!)
					.toolbar { Button(action: { viewModel.isShowingProfileSheet = false }, label: { XDismissButton() }) }
			}
		}
		.alert(item: $viewModel.alertItem, content: { $0.alert })
		.navigationTitle(viewModel.location.name)
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationView {
		LocationDetailView(
			viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.chipotle))
		)
	}
}

// MARK: - Sub Views
fileprivate struct BannerImageView: View {
	// MARK: - Properties
	var image: UIImage
	
	var body: some View {
		Image(uiImage: image)
			.resizable()
			.scaledToFill()
			.frame(height: 120)
			.accessibilityHidden(true)
	}
}


fileprivate struct AddressHStack: View {
	// MARK: - Properites
	var address: String
	
	var body: some View {
		HStack {
			Label(address, systemImage: "mappin.and.ellipse")
				.font(.caption)
				.foregroundColor(.secondary)
			Spacer()
		}
		.padding(.horizontal)
	}
}


fileprivate struct DescriptionView: View {
	// MARK: - Properties
	var text: String
	
	var body: some View {
		Text(text)
			.minimumScaleFactor(0.75)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.horizontal)
	}
}


fileprivate struct ActionButtonHStack: View {
	@ObservedObject var viewModel: LocationDetailViewModel
	
	var body: some View {
		HStack(spacing: 20) {
			Button {
				viewModel.getDirectionsToLocation()
			} label: {
				LocationActionButton(imageColor: .brandPrimary, imageName: "location.fill")
			}
			.accessibilityLabel(Text("Get directions."))
			
			Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
				LocationActionButton(imageColor: .brandPrimary, imageName: "network")
			})
			.accessibilityRemoveTraits(.isButton)
			.accessibilityLabel(Text("Goto website."))
			
			Button {
				viewModel.callLocation()
			} label: {
				LocationActionButton(imageColor: .brandPrimary, imageName: "phone.fill")
			}
			.accessibilityLabel(Text("Call location."))
			
			// Only show this button if we have a profile.
			if let _ = CloudKitManager.shared.profileRecordID {
				Button {
					viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
				} label: {
					LocationActionButton(imageColor: viewModel.buttonColor, imageName: viewModel.buttonImageTitle)
				}
				.accessibilityLabel(Text(viewModel.buttonA11yLabel))
				.disabled(viewModel.isLoading)
			}
		}
		.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
		.background(Color(.secondarySystemBackground))
		.clipShape(Capsule())
	}
}

fileprivate struct GridHeaderTextView: View {
	var number: Int

	var body: some View {
		Text("Who's Here")
			.bold()
			.font(.title2)
			.accessibilityAddTraits(.isHeader)
			.accessibilityLabel(Text("Who's here \(number) checked in."))
			.accessibilityHint(Text("Bottom section is scrollable."))
	}
}


fileprivate struct FullScreenBlackTransparencyView: View {
	var body: some View {
		Color(.black)
			.ignoresSafeArea()
			.opacity(0.9)
			.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
			.animation(.easeOut)
			.zIndex(1)
			.accessibilityHidden(true)
	}
}

fileprivate struct AvatarGridView: View {
	// MARK: - Environment
	@Environment(\.sizeCategory) var sizeCategory
	
	// MARK: - Properties
	@ObservedObject var viewModel: LocationDetailViewModel
	
	var body: some View {
		ZStack {
			if viewModel.checkedInProfiles.isEmpty {
				if #available(iOS 17.0, *) {
					ContentUnavailableView(
						"Nobody's Here",
						systemImage: "person.2.slash.fill",
						description: Text("Invite fellow developers to join you at this restaurant.")
					)
				} else {
					// Fallback on earlier versions
					GridEmptyStateTextView()
				}
			} else {
				ScrollView(showsIndicators: false) {
					LazyVGrid(columns: viewModel.determineColumns(for: sizeCategory), content: {
						ForEach(viewModel.checkedInProfiles) { profile in
							FirstNameAvatarView(profile: profile)
								.onTapGesture { viewModel.show(profile, in: sizeCategory) }
						}
					})
				}
			}
			
			if viewModel.isLoading { LoadingView() }
		}
	}
}


fileprivate struct GridEmptyStateTextView: View {
	var body: some View {
		Text("Nobody's Here 😢")
			.bold()
			.font(.title2)
			.foregroundColor(.secondary)
			.padding(.top, 30)
	}
}
