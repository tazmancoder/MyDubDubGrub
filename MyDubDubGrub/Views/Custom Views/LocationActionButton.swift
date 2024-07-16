//
//  LocationActionButton.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationActionButton: View {
	var imageColor: Color
	var imageName: String
	
    var body: some View {
		ZStack {
			Circle()
				.fill(
					Color.brandPrimary.gradient
						.shadow(.drop(color: .black.opacity(0.8), radius: 3))
				)
				.frame(width: 60, height: 60)
			Image(systemName: imageName)
				.resizable()
				.scaledToFit()
				.frame(width: 22, height: 22)
				.foregroundStyle(
					.white
						.shadow(.drop(color: .black.opacity(0.8), radius: 2))
				)
		}
    }
}

#Preview {
	LocationActionButton(imageColor: .brandPrimary, imageName: "person.fill.checkmark")
}
