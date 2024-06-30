//
//  MyDubDubGrubApp.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/29/24.
//

import SwiftUI

@main
struct MyDubDubGrubApp: App {
	// MARK: - Observable Objects
	let locationManager = LocationManager()
	
    var body: some Scene {
        WindowGroup {
            AppTabView()
				.environmentObject(locationManager)
        }
    }
}
