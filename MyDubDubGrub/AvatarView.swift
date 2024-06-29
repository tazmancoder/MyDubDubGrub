//
//  AvatarView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct AvatarView: View {
    var body: some View {
		Image(.defaultAvatar)
			.resizable()
			.scaledToFit()
			.frame(width: 35, height: 35)
			.clipShape(Circle())
    }
}

#Preview {
    AvatarView()
}
