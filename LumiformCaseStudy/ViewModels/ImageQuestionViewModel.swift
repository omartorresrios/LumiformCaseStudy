//
//  ImageQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import Foundation

final class ImageQuestionViewModel: GenericItemViewModel {
	private let imageService: ImageService
	private let question: ImageQuestion
	private let _nestingLevel: Int
	var onImageLoaded: ((Data) -> Void)?
	var type: String { return "image" }
	
	var questionTitle: String {
		question.title
	}
	
	var nestingLevel: Int {
		_nestingLevel
	}
	
	init(imageService: ImageService, question: ImageQuestion, nestingLevel: Int = 0) {
		self.imageService = imageService
		self.question = question
		self._nestingLevel = nestingLevel
	}
	
	func loadImage(fullSize: Bool) {
		if let url = URL(string: question.src) {
			imageService.fetchImage(from: url) { [weak self] result in
				if case .success(let imageData) = result {
					let processedData: Data
					if fullSize {
						processedData = imageData
					} else {
						processedData = ImageCache.resizedImageData(imageData,
																	toSize: CGSize(width: 100, height: 100)) ?? imageData
					}
					DispatchQueue.main.async {
						self?.onImageLoaded?(processedData)
					}
				}
			}
		}
	}
}
