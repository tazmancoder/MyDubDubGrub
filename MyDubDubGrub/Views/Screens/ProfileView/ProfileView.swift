//
//  ProfileView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI
import CloudKit
import PhotosUI

@MainActor
struct ProfileView: View {
	// MARK: - State Object
	@State private var viewModel = ProfileViewModel()
	@FocusState private var focusTextField: ProfileTextField?
	
	enum ProfileTextField {
		case firstName, lastName, companyName, bio
	}
	
	var body: some View {
		ZStack {
			VStack {
				HStack(spacing: 16) {
					ProfileImageView(viewModel: viewModel)
					
					VStack(spacing: 1) {
						TextField("First Name", text: $viewModel.firstName)
							.profileNameStyle()
							.focused($focusTextField, equals: .firstName)
							.onSubmit { focusTextField = .lastName }
							.submitLabel(.next)
						
						TextField("Last Name", text: $viewModel.lastName)
							.profileNameStyle()
							.focused($focusTextField, equals: .lastName)
							.onSubmit { focusTextField = .companyName }
							.submitLabel(.next)

						TextField("Company Name", text: $viewModel.companyName)
							.focused($focusTextField, equals: .companyName)
							.onSubmit { focusTextField = .bio }
							.submitLabel(.next)
					}
					.padding(.trailing, 16)
				}
				.padding(.vertical)
				.background(Color(.secondarySystemBackground))
				.cornerRadius(12)
				.padding(.horizontal)
				
				VStack(alignment: .leading, spacing: 8) {
					HStack {
						CharactersRemainView(currentCount: viewModel.bio.count)
							.accessibilityAddTraits(.isHeader)
						
						Spacer()
						
						if viewModel.isCheckedIn {
							Button {
								viewModel.checkOut()
							} label: {
								CheckoutButton()
							}
							.disabled(viewModel.isLoading)
						}
					}
					
//					BioTextEditor(text: $viewModel.bio)
// I think I'm going to leave this way of entering the bio. But I will leave the code for the old
// TextEditor.
					
					TextField("Enter your bio", text: $viewModel.bio, axis: .vertical)
						.textFieldStyle(.roundedBorder)
						.lineLimit(3...12)
						.focused($focusTextField, equals: .bio)
						.accessibilityHint(Text("This text field is for your bio and has a 100 character maximum."))
				}
				.padding(.horizontal)
				
				Spacer()
				
				Button {
					viewModel.determineButtonAction()
				} label: {
					DDGButton(title: viewModel.buttonTitle)
				}
				.padding(.bottom)
			}
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					Button(action: { focusTextField = nil }, label: {
						Text("Dismiss")
					})
				}
			}
			
			if viewModel.isLoading { LoadingView() }
		}
		.navigationTitle("Profile")
		.navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
		.ignoresSafeArea(.keyboard)
		.task {
			viewModel.getProfile()
			viewModel.getCheckedInStatus()
		}
		.alert(item: $viewModel.alertItem, content: { $0.alert })
	}
}

#Preview {
	NavigationStack {
		ProfileView()
	}
}

// MARK: - Sub Views
fileprivate struct ProfileImageView: View {
	// MARK: - Properties
	var viewModel: ProfileView.ProfileViewModel
	
	// MARK: - State
	@State private var selectedImage: PhotosPickerItem?
	
	var body: some View {
		ZStack(alignment: .bottom) {
			AvatarView(image: viewModel.avatar, size: 84)
			
			PhotosPicker(selection: $selectedImage, matching: .images) {
				Image(systemName: "square.and.pencil")
					.resizable()
					.scaledToFit()
					.frame(width: 14, height: 14)
					.foregroundColor(.white)
					.padding(.bottom, 6)
			}
		}
		.accessibilityElement(children: .ignore)
		.accessibilityAddTraits(.isButton)
		.accessibilityLabel(Text("Profile Photo"))
		.accessibilityHint(Text("Opens the Apples photo picker."))
		.padding(.leading, 12)
		.onChange(of: selectedImage) { _, _ in
			Task {
				if let pickerItem = selectedImage, let data = try? await pickerItem.loadTransferable(type: Data.self) {
					if let image = UIImage(data: data) {
						viewModel.avatar = image
					}
				}
			}
		}
	}
}


fileprivate struct CharactersRemainView: View {
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


fileprivate struct CheckoutButton: View {
	var body: some View {
		Label("Check Out", systemImage: "mappin.and.ellipse")
			.font(.system(size: 12, weight: .semibold))
			.foregroundColor(.white)
			.padding(10)
			.frame(height: 28)
			.background(Color.grubRed)
			.cornerRadius(8)
			.accessibilityLabel(Text("Check out of current location."))
	}
}


fileprivate struct BioTextEditor: View {
	var text: Binding<String>
	
	var body: some View {
		TextEditor(text: text)
			.frame(height: 100)
			.overlay { RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1.0) }
			.accessibilityHint(Text("This text field is for your bio and has a 100 character maximum."))
	}
}
