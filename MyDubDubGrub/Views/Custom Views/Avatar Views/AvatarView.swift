//
//  AvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct AvatarView: View {
	var image: UIImage
	var size: CGFloat
	
    var body: some View {
		Image(uiImage: image)
			.resizable()
			.scaledToFit()
			.frame(width: size, height: size)
			.clipShape(Circle())
    }
}

#Preview {
	AvatarView(image: PlaceHolderImage.avatar, size: 90)
}
