//
//  AppTabViewModel.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/4/24.
//

import Foundation
import SwiftUI

extension AppTabView {
	final class AppTabViewModel: ObservableObject {
		// MARK: - Properties
		@Published var isShowingOnboardView = false
		@AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
			didSet { isShowingOnboardView = hasSeenOnboardView }
		}
		
		let kHasSeenOnboardView = "hasSeenOnboardView"
				
		// MARK: - Functions
		func checkIfHasSeenOnboard() {
			if !hasSeenOnboardView { hasSeenOnboardView = true }
		}
	}
}
