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
			Image(uiImage: location.createSquareImage())
				.resizable()
				.scaledToFit()
				.frame(width: 80, height: 80)
				.clipShape(Circle())
				.padding(.vertical, 8)
			
			VStack(alignment: .leading) {
				Text(location.name)
					.font(.title2)
					.fontWeight(.semibold)
					.lineLimit(1)
					.minimumScaleFactor(0.75)
				
				HStack {
					AvatarView(size: 35)
					AvatarView(size: 35)
					AvatarView(size: 35)
					AvatarView(size: 35)
					AvatarView(size: 35)
				}
			}
			.padding(.leading)
		}
	}
}

#Preview {
	LocationCell(location: DDGLocation(record: MockData.location))
}