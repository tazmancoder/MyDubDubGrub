//
//  XDismissButton.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
		ZStack {
			Circle()
				.frame(width: 30, height: 30)
				.foregroundColor(.brandPrimary)
			Image(systemName: "xmark")
				.foregroundColor(.white)
				.imageScale(.small)
				.frame(width: 44, height: 44)
		}
    }
}

#Preview {
    XDismissButton()
}
