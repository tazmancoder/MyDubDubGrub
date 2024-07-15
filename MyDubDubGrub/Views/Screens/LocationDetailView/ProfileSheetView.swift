//
//  ProfileSheetView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/5/24.
//

import SwiftUI

// Alternative profile modal view for larger dynamic type sizes
// We present this as a sheet when are sizeCategory gets into the
// accessibility sizes
struct ProfileSheetView: View {
	var profile: DDGProfile
	
    var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				Image(uiImage: profile.avatarImage)
					.resizable()
					.scaledToFill()
					.frame(width: 110, height: 110)
					.clipShape(Circle())
					.shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
					.accessibilityHidden(true)
				
				Text(profile.firstName + " " + profile.lastName)
					.bold()
					.font(.title2)
					.minimumScaleFactor(0.9)
				
				Text(profile.companyName)
					.fontWeight(.semibold)
					.foregroundColor(.secondary)
					.minimumScaleFactor(0.75)
					.accessibilityLabel(Text("Works at \(profile.companyName)"))
				
				Text(profile.bio)
					.accessibilityLabel(Text("Bio, \(profile.bio)"))
			}
			.padding()
		}
    }
}

#Preview {
	ProfileSheetView(profile: DDGProfile(record: MockData.profile))
}
