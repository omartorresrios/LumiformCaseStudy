//
//  ImageQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import Foundation
import UIKit

final class ImageQuestionViewModel: GenericItemViewModel {
	private let imageService: ImageService
	let question: ImageQuestion
	let nestingLevel: Int
	var onImageLoaded: ((UIImage) -> Void)?
	var type: String { return "image" }
	
	init(imageService: ImageService, question: ImageQuestion, nestingLevel: Int = 0) {
		self.imageService = imageService
		self.question = question
		self.nestingLevel = nestingLevel
	}
	
	func loadImage() {
		if let url = URL(string: question.src) {
			imageService.fetchImage(from: url) { [weak self] result in
				if case .success(let image) = result {
					let resizedImage = ImageCache.resizedImage(image, toSize: CGSize(width: 100, height: 100))
					DispatchQueue.main.async {
						guard let resizedImage = resizedImage else { return }
						self?.onImageLoaded?(resizedImage)
					}
				}
			}
		}
	}
}
