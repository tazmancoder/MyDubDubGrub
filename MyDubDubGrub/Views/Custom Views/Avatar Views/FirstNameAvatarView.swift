//
//  FirstNameAvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct FirstNameAvatarView: View {
	// MARK: - Environment
	@Environment(\.dynamicTypeSize) var dynamicTypeSize
	
	// MARK: - Properties
	var profile: DDGProfile

    var body: some View {
		VStack {
			AvatarView(image: profile.avatarImage, size: dynamicTypeSize >= .accessibility3 ? 100 : 64)
			Text(profile.firstName)
				.bold()
				.lineLimit(1)
				.minimumScaleFactor(0.75)
		}
		.accessibilityElement(children: .ignore)
		.accessibilityAddTraits(.isButton)
		.accessibilityHint(Text("Show \(profile.firstName)'s profile popup."))
		.accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
    }
}

#Preview {
	FirstNameAvatarView(profile: DDGProfile(record: MockData.profile))
}
