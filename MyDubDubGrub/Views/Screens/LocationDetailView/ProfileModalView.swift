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
	
    var body: some View {
		ZStack {
			VStack {
				Spacer().frame(height: 60)
				
				Text("\(profile.firstName) \(profile.lastName)")
					.bold()
					.font(.title2)
					.lineLimit(1)
					.minimumScaleFactor(0.75)

				Text(profile.companyName)
					.fontWeight(.semibold)
					.foregroundColor(.secondary)
					.lineLimit(1)
					.minimumScaleFactor(0.75)

				Text(profile.bio)
					.lineLimit(3)
					.padding()

			}
			.frame(width: 300, height: 230)
			.background(Color(.secondarySystemBackground))
			.cornerRadius(16)
			.overlay(Button {
				
			} label: {
				XDismissButton()
					.padding(5)
			}, alignment: .topTrailing)
			
			Image(uiImage: profile.avatar.convertToUIImage(in: .square))
				.resizable()
				.scaledToFill()
				.frame(width: 110, height: 110)
				.clipShape(Circle())
				.shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
				.offset(y: -120)
		}
    }
}

#Preview {
	ProfileModalView(profile: DDGProfile(record: MockData.profile))
}
