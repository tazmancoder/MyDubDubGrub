//
//  PhotoPicker.swift
//  MyDubDubGrub
//
//  Created by Mark Perryman on 7/1/24.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
	@Binding var image: UIImage
	
	func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = context.coordinator
		
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(photoPicker: self)
	}
	
	final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let photoPicker: PhotoPicker
		
		init(photoPicker: PhotoPicker) { self.photoPicker = photoPicker }
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			if let image = info[.editedImage] as? UIImage { photoPicker.image = image }
			picker.dismiss(animated: true)
		}
	}
}
