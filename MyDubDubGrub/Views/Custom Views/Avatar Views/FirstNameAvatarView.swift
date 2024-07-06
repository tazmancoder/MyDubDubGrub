//
//  FirstNameAvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct FirstNameAvatarView: View {
	// MARK: - Environment
	@Environment(\.sizeCategory) var sizeCategory
	
	// MARK: - Properties
	var profile: DDGProfile

    var body: some View {
		VStack {
			AvatarView(image: profile.createAvatarImage(), size: sizeCategory >= .accessibilityMedium ? 100 : 64)
			Text(profile.firstName)
				.bold()
				.lineLimit(1)
				.minimumScaleFactor(0.75)
		}
    }
}

#Preview {
	FirstNameAvatarView(profile: DDGProfile(record: MockData.profile))
}
