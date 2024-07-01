//
//  ProfileView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct ProfileView: View {
	// MARK: - State
	@State private var firstName = ""
	@State private var lastName = ""
	@State private var companyName = ""
	@State private var bio = ""
	@State private var avatar = PlaceHolderImage.avatar
	@State private var isShowingPhotoPicker = false
	
    var body: some View {
		VStack {
			ZStack {
				NameBackgroundView()
				
				HStack(spacing: 16) {
					ZStack {
						AvatarView(image: avatar, size: 84)
						EditImage()
					}
					.padding(.leading, 12)
					.onTapGesture {
						isShowingPhotoPicker = true
					}

					VStack(spacing: 1) {
						TextField("First Name", text: $firstName)
							.profileNameStyle()
						TextField("Last Name", text: $lastName)
							.profileNameStyle()
						TextField("Company Name", text: $companyName)
					}
					.padding(.trailing, 16)
				}
				.padding()
			}
			
			VStack(alignment: .leading, spacing: 8) {
				CharactersRemainView(currentCount: bio.count)
				TextEditor(text: $bio)
					.frame(height: 100)
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color.secondary, lineWidth: 1.0)
					)
			}
			.padding(.horizontal)
			
			Spacer()
			
			Button {
				
			} label: {
				DDGButton(title: "Create Profile")
			}
		}
		.navigationTitle("Profile")
		.sheet(isPresented: $isShowingPhotoPicker) {
			PhotoPicker(image: $avatar)
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
		+ Text("\(100 - currentCount)")
			.font(.callout)
			.bold()
			.foregroundColor(currentCount <= 100 ? .brandPrimary : Color(.systemPink))
		+ Text(" Characters Remain")
			.font(.callout)
			.foregroundColor(.secondary)
	}
}
