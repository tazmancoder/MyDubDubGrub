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
		Image(.ddgMapLogo)
			.resizable()
			.scaledToFit()
			.frame(width: frameWidth)
	}
}

#Preview {
	LogoView(frameWidth: 250)
}
