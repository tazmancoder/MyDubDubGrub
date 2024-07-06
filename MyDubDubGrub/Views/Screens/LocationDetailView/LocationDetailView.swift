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
								playHaptic()
							} label: {
								LocationActionButton(
									imageColor: viewModel.isCheckedIn ? .grubRed : .brandPrimary,
									imageName: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark"
								)
							}
							.accessibilityLabel(Text(viewModel.isCheckedIn ? "Check out of location." : "Check into location."))
						}
					}
				}
				.padding(.horizontal)
				
				
				// Who's at this location
				Text("Who's Here")
					.bold()
					.font(.title2)
					.accessibilityAddTraits(.isHeader)
					.accessibilityLabel(Text("Who's here \(viewModel.checkedInProfiles.count) checked in."))
					.accessibilityHint(Text("Bottom section is scrollable."))
				
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
							Text("Nobody's Here 😢")
								.bold()
								.font(.title2)
								.foregroundColor(.secondary)
								.padding(.top, 30)
						}
					} else {
						ScrollView(showsIndicators: false) {
							LazyVGrid(columns: viewModel.determineColumns(for: sizeCategory), content: {
								ForEach(viewModel.checkedInProfiles) { profile in
									FirstNameAvatarView(profile: profile)
										.accessibilityElement(children: .ignore)
										.accessibilityAddTraits(.isButton)
										.accessibilityHint(Text("Show \(profile.firstName)'s profile popup."))
										.accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
										.onTapGesture {
											viewModel.show(profile: profile, in: sizeCategory)
										}
								}
							})
						}
					}
					
					if viewModel.isLoading { LoadingView() }
				}
				
				Spacer()
			}
			.accessibilityHidden(viewModel.isShowingProfileModal)

			if viewModel.isShowingProfileModal {
				Color(.black)
					.ignoresSafeArea()
					.opacity(0.9)
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
					.animation(.easeOut)
					.zIndex(1)
					.accessibilityHidden(true)
				
				ProfileModalView(profile: viewModel.selectedProfile!, isShowingProfileModal: $viewModel.isShowingProfileModal)
					.transition(.opacity.combined(with: .slide))
					.animation(.easeOut)
					.zIndex(2)
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
		.alert(item: $viewModel.alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.navigationTitle(viewModel.location.name)
		.navigationBarTitleDisplayMode(.inline)
	}
}

//#Preview {
//	NavigationView {
//		LocationDetailView(
//			viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.chipotle))
//		)
//	}
//}

// MARK: - Sub Views
struct BannerImageView: View {
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
			.minimumScaleFactor(0.75)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.horizontal)
	}
}
