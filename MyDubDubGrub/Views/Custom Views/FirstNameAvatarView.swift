//
//  FirstNameAvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct FirstNameAvatarView: View {
	var firstName: String
	
    var body: some View {
		VStack {
			AvatarView(size: 64)
			Text(firstName)
				.bold()
				.lineLimit(1)
				.minimumScaleFactor(0.75)
		}
    }
}

#Preview {
	FirstNameAvatarView(firstName: "Devon")
}
