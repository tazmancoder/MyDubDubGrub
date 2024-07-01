//
//  CustomModifiers.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct ProfileNameText: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.system(size: 28, weight: .bold))
			.lineLimit(1)
			.minimumScaleFactor(0.75)
	}
}

