//
//  DDGAnnotation.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import SwiftUI

struct DDGAnnotation: View {
	// MARK: - Properties
	var location: DDGLocation
	var number: Int
	
    var body: some View {
		VStack {
			ZStack {
				MapBallon()
					.fill(.brandPrimary.gradient)
					.frame(width: 100, height: 70)
				
				Image(uiImage: location.squareImage)
					.resizable()
					.frame(width: 40, height: 40)
					.clipShape(Circle())
					.offset(y: -11)
				
				if number > 0 {
					Text("\(min(number, 99))")
						.font(.system(size: 11, weight: .bold))
						.frame(width: 26, height: 18)
						.background(Color.grubRed)
						.foregroundColor(.white)
						.clipShape(Capsule())
						.offset(x: 20, y: -28)
				}
			}
			
			Text(location.name)
				.font(.caption)
				.fontWeight(.semibold)
		}
    }
}

#Preview {
	DDGAnnotation(location: DDGLocation(record: MockData.location), number: 44)
}
