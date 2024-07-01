//
//  LocationManager.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 6/30/24.
//

import Foundation

final class LocationManager: ObservableObject {
	@Published var locations: [DDGLocation] = []
}
