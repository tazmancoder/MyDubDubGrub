//
//  AvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct AvatarView: View {
	var size: CGFloat
	
    var body: some View {
		Image(.defaultAvatar)
			.resizable()
			.scaledToFit()
			.frame(width: size, height: size)
			.clipShape(Circle())
    }
}

#Preview {
	AvatarView(size: 35)
}
