//
//  LocationCell.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationCell: View {
	// MARK: - Properties
	var location: DDGLocation
	var profiles: [DDGProfile]
	
    var body: some View {
		HStack {
			Image(uiImage: location.createSquareImage())
				.resizable()
				.scaledToFit()
				.frame(width: 70, height: 70)
				.clipShape(Circle())
				.padding(.vertical, 8)
			
			VStack(alignment: .leading) {
				Text(location.name)
					.font(.title2)
					.fontWeight(.semibold)
					.lineLimit(1)
					.minimumScaleFactor(0.75)
				
				if profiles.isEmpty {
					Text("Nobody's Checked In")
						.fontWeight(.semibold)
						.foregroundColor(.secondary)
				} else {
					HStack {
						ForEach(profiles.indices, id: \.self) { index in
							if index <= 3 {
								AvatarView(image: profiles[index].createAvatarImage(), size: 30)
							} else if index == 4 {
								AdditionalProfileView(number: profiles.count - 4)
							}
						}
					}
				}
			}
			.padding(.leading)
		}
	}
}

#Preview {
	LocationCell(location: DDGLocation(record: MockData.location), profiles: [])
}

struct AdditionalProfileView: View {
	var number: Int
	
	var body: some View {
		Text("+\(number)")
			.font(.system(size: 11, weight: .semibold))
			.frame(width: 30, height: 30)
			.foregroundColor(.white)
			.background(Color.brandPrimary)
			.clipShape(Circle())
	}
}
