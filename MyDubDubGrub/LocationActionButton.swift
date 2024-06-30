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
				.foregroundColor(imageColor)
				.frame(width: 60, height: 60)
			Image(systemName: imageName)
				.resizable()
				.scaledToFit()
				.frame(width: 22, height: 22)
				.foregroundColor(.white)
		}
    }
}

#Preview {
	LocationActionButton(imageColor: .brandPrimary, imageName: "person.fill.checkmark")
}
