//
//  LocationListView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
		NavigationView {
			List {
				ForEach(0..<10) { item in
					HStack {
						Image(.defaultSquareAsset)
							.resizable()
							.scaledToFit()
							.frame(width: 80, height: 80)
							.clipShape(Circle())
							.padding(.vertical, 8)
						
						VStack(alignment: .leading) {
							Text("Test Location Name")
								.font(.title2)
								.fontWeight(.semibold)
								.lineLimit(1)
								.minimumScaleFactor(0.75)
							
							// Avatar Images
							HStack {
								AvatarView()
								AvatarView()
								AvatarView()
								AvatarView()
								AvatarView()
							}
						}
						.padding(.leading, 8)
					}
				}
			}
			.navigationTitle("Grub Spots")
		}
    }
}

#Preview {
    LocationListView()
}
