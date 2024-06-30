//
//  LocationCell.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationCell: View {
	var location: DDGLocation
	
    var body: some View {
		HStack {
			Image(.defaultSquareAsset)
				.resizable()
				.scaledToFit()
				.frame(width: 80, height: 80)
				.clipShape(Circle())
				.padding(.vertical, 8)
			
			VStack(alignment: .leading) {
				Text(location.name)
					.font(.title2)
					.fontWeight(.semibold)
					.minimumScaleFactor(0.75)
					.lineLimit(1)

				// Avatar Images
				HStack {
					AvatarView(size: 32)
					AvatarView(size: 32)
					AvatarView(size: 32)
					AvatarView(size: 32)
					AvatarView(size: 32)
				}
			}
			.padding(.leading, 8)
		}

    }
}

#Preview {
	LocationCell(location: DDGLocation(record: MockData.location))
}
