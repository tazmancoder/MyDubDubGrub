//
//  DDGButton.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct DDGButton: View {
	// MARK: - Properties
	var title: String
	
    var body: some View {
		Text(title)
			.bold()
			.frame(width: 280, height: 44)
			.background(.brandPrimary.gradient)
			.foregroundColor(.white)
			.cornerRadius(8)
    }
}

#Preview("Light Mode") {
	DDGButton(title: "Create Profile")
}

#Preview("Dark Mode") {
	DDGButton(title: "Create Profile")
		.preferredColorScheme(.dark)
}

//#Preview("Dark Landscape", traits: .landscapeRight) {
//	DDGButton(title: "Create Profile")
//		.preferredColorScheme(.dark)
//}
