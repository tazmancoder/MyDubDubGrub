//
//  LogoView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import SwiftUI

struct LogoView: View {
	var frameWidth: CGFloat
	
	var body: some View {
// You can initialize any image with decorative to hide it from voice over
// This doesn't work on UIImages
//		Image(decorative: "ddg-map-logo")
		Image(.ddgMapLogo)
			.resizable()
			.scaledToFit()
			.frame(width: frameWidth)
	}
}

#Preview {
	LogoView(frameWidth: 250)
}
