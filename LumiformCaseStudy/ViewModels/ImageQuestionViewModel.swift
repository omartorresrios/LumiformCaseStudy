//
//  ImageQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class ImageQuestionViewModel: GenericItemViewModel {
	let question: ImageQuestion
	let nestingLevel: Int
	var type: String { return "image" }
	
	init(question: ImageQuestion, nestingLevel: Int = 0) {
		self.question = question
		self.nestingLevel = nestingLevel
	}
}
