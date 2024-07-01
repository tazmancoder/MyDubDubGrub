//
//  OnBoardView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import SwiftUI

struct OnBoardView: View {
    var body: some View {
		VStack {
			HStack {
				Spacer()
				Button {
					
				} label: {
					XDismissButton()
				}
			}

			Spacer()
			
			LogoView(frameWidth: 250)
				.padding(.bottom)
			
			VStack(alignment: .leading, spacing: 32) {
				OnboardInfoView(
					imageName: "building.2.crop.circle",
					title: "Resturaunt Locations",
					description: "Find place to dine around the convention center."
				)
				
				OnboardInfoView(
					imageName: "checkmark.circle",
					title: "Check In",
					description: "Let other iOS devs know where you are."
				)
				
				OnboardInfoView(
					imageName: "person.2.circle",
					title: "Find Friends",
					description: "See where other iOS devs are and join the party."
				)
			}
			
			Spacer()
		}
		.padding(.horizontal, 40)
    }
}

#Preview {
    OnBoardView()
}

struct OnboardInfoView: View {
	var imageName: String
	var title: String
	var description: String
	
	var body: some View {
		HStack(spacing: 26) {
			Image(systemName: imageName)
				.resizable()
				.frame(width: 50, height: 50)
				.foregroundColor(.brandPrimary)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(title)
					.bold()
				Text(description)
					.foregroundColor(.secondary)
					.lineLimit(2)
					.minimumScaleFactor(0.75)
			}
		}
	}
}
