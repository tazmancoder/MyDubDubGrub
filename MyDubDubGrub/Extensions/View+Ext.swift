//
//  View+Ext.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

extension View {
	func profileNameStyle() -> some View {
		self.modifier(ProfileNameText())
	}
}
