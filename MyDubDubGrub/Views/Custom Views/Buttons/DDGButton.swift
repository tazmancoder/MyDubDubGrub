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
			.background(Color.brandPrimary.gradient)
			.foregroundColor(.white)
			.cornerRadius(8)
    }
}

#Preview {
	DDGButton(title: "Create Profile")
}
