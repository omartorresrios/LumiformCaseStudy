//
//  ImageQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import Foundation

final class ImageQuestionViewModel: GenericItemViewModel {
	enum LoadingState {
		case idle
		case loading
		case loaded
		case error(Error)
	}
	
	private let imageService: ImageService
	private let question: ImageQuestion
	private let _nestingLevel: Int
	var onImageLoaded: ((Data) -> Void)?
	var onStateChanged: ((LoadingState) -> Void)?
	
	private(set) var loadingState: LoadingState = .idle {
		didSet {
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.onStateChanged?(self.loadingState)
			}
		}
	}
	
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
		guard let url = URL(string: question.src) else {
			loadingState = .error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
			return
		}
		
		loadingState = .loading
		
		imageService.fetchImage(from: url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let imageData):
				let processedData: Data
				if fullSize {
					processedData = imageData
				} else {
					processedData = ImageCache.resizedImageData(imageData,
																toSize: CGSize(width: 100, height: 100)) ?? imageData
				}
				self.onImageLoaded?(processedData)
				self.loadingState = .loaded
				
			case .failure(let error):
				self.loadingState = .error(error)
			}
		}
	}
}
