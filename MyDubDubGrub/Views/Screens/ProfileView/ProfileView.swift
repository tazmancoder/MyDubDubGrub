//
//  ProfileView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
	// MARK: - State Object
	@StateObject private var viewModel = ProfileViewModel()
	
    var body: some View {
		ZStack {
			VStack {
				ZStack {
					NameBackgroundView()
					
					HStack(spacing: 16) {
						ZStack {
							AvatarView(image: viewModel.avatar, size: 84)
							EditImage()
						}
						.accessibilityElement(children: .ignore)
						.accessibilityAddTraits(.isButton)
						.accessibilityLabel(Text("Profile Photo"))
						.accessibilityHint(Text("Opens the Apples photo picker."))
						.padding(.leading, 12)
						.onTapGesture {
							viewModel.isShowingPhotoPicker = true
						}
						
						VStack(spacing: 1) {
							TextField("First Name", text: $viewModel.firstName)
								.profileNameStyle()
							TextField("Last Name", text: $viewModel.lastName)
								.profileNameStyle()
							TextField("Company Name", text: $viewModel.companyName)
						}
						.padding(.trailing, 16)
					}
					.padding()
				}
				
				VStack(alignment: .leading, spacing: 8) {
					HStack {
						CharactersRemainView(currentCount: viewModel.bio.count)
							.accessibilityAddTraits(.isHeader)
						
						Spacer()
						
						if viewModel.isCheckedIn {
							Button {
								viewModel.checkOut()
							} label: {
								Label("Check Out", systemImage: "mappin.and.ellipse")
									.font(.system(size: 12, weight: .semibold))
									.foregroundColor(.white)
									.padding(10)
									.frame(height: 28)
									.background(Color.grubRed)
									.cornerRadius(8)
							}
							.accessibilityLabel(Text("Check out of current location."))
						}
					}
					TextEditor(text: $viewModel.bio)
						.frame(height: 100)
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color.secondary, lineWidth: 1.0)
						)
						.accessibilityHint(Text("This text field is for your bio and has a 100 character maximum."))
				}
				.padding(.horizontal)
				
				Spacer()
				
				Button {
					viewModel.profileContext == .create ? viewModel.createProfile() : viewModel.updateProfile()
				} label: {
					DDGButton(title: viewModel.profileContext == .create ? "Create Profile" : "Update Profile")
				}
				.padding(.bottom)
			}
			
			if viewModel.isLoading {
				LoadingView()
			}
		}
		.navigationTitle("Profile")
		.navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
		.toolbar {
			Button {
				dismissKeyboard()
			} label: {
				Image(systemName: "keyboard.chevron.compact.down")
			}
		}
		.onAppear {
			viewModel.getProfile()
			viewModel.getCheckedInStatus()
		}
		.alert(item: $viewModel.alertItem, content: { alertItem in
			Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
		})
		.sheet(isPresented: $viewModel.isShowingPhotoPicker) {
			PhotoPicker(image: $viewModel.avatar)
		}
    }	
}

#Preview {
	NavigationView {
		ProfileView()
	}
}

// MARK: - Sub Views
struct NameBackgroundView: View {
	var body: some View {
		Color(.secondarySystemBackground)
			.frame(height: 130)
			.cornerRadius(12)
			.padding(.horizontal)
	}
}

struct EditImage: View {
	var body: some View {
		Image(systemName: "square.and.pencil")
			.resizable()
			.scaledToFit()
			.frame(width: 14, height: 14)
			.foregroundColor(.white)
			.offset(y: 30)
	}
}

struct CharactersRemainView: View {
	// MARK: - Properties
	var currentCount: Int
	
	var body: some View {
		Text("Bio: ")
			.font(.callout)
			.foregroundColor(.secondary)
		+ Text("\(Bio.totalCharacter - currentCount)")
			.font(.callout)
			.bold()
			.foregroundColor(currentCount <= Bio.totalCharacter ? .brandPrimary : Color(.systemPink))
		+ Text(" Characters Remain")
			.font(.callout)
			.foregroundColor(.secondary)
	}
}
