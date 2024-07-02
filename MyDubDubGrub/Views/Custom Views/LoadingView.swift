//
//  LoadingView.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
		ZStack {
			Color(.systemBackground)
				.opacity(0.9)
				.ignoresSafeArea()
			
			ProgressView()
				.progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
				.scaleEffect(2)
				.offset(y: -40)
		}
    }
}

#Preview {
    LoadingView()
}
