//
//  ImageQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class ImageQuestionViewModel: GenericItemViewModel {
	let question: ImageQuestion
	var type: String { return "image" }
	
	init(question: ImageQuestion) {
		self.question = question
	}
}
