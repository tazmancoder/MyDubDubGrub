//
//  FirstNameAvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct FirstNameAvatarView: View {
	var profile: DDGProfile
	
    var body: some View {
		VStack {
			AvatarView(image: profile.createAvatarImage(), size: 64)
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
