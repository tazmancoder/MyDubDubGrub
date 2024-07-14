//
//  ProfileModalView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/2/24.
//

import SwiftUI

struct ProfileModalView: View {
	// MARK: - Property
	var profile: DDGProfile
	
	@Binding var isShowingProfileModal: Bool
	
	var body: some View {
		ZStack {
			VStack {
				Spacer().frame(height: 60)
				
				Text(profile.firstName + " " + profile.lastName)
					.bold()
					.font(.title2)
					.lineLimit(1)
					.minimumScaleFactor(0.75)
					.padding(.horizontal)
				
				Text(profile.companyName)
					.fontWeight(.semibold)
					.foregroundColor(.secondary)
					.lineLimit(1)
					.minimumScaleFactor(0.75)
					.accessibilityLabel(Text("Works at \(profile.companyName)"))
					.padding(.horizontal)

				Text(profile.bio)
					.lineLimit(3)
					.padding()
					.accessibilityLabel(Text("Bio, \(profile.bio)"))
				
			}
			.frame(width: 300, height: 230)
			.background(Color(.secondarySystemBackground))
			.cornerRadius(16)
			.overlay(Button {
				withAnimation { isShowingProfileModal = false }
			} label: {
				XDismissButton()
					.padding(5)
			}, alignment: .topTrailing)
			
			Image(uiImage: profile.avatarImage)
				.resizable()
				.scaledToFill()
				.frame(width: 110, height: 110)
				.clipShape(Circle())
				.shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
				.offset(y: -120)
				.accessibilityHidden(true)
		}
		.transition(.opacity.combined(with: .slide))
		.animation(.easeOut)
		.zIndex(2)
	}
}

#Preview {
	ProfileModalView(profile: DDGProfile(record: MockData.profile), isShowingProfileModal: .constant(true))
}
