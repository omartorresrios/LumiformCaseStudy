//
//  TextQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class TextQuestionViewModel: GenericItemViewModel {
	let question: TextQuestion
	let nestingLevel: Int
	var type: String { return "text" }
	
	init(question: TextQuestion, nestingLevel: Int = 0) {
		self.question = question
		self.nestingLevel = nestingLevel
	}
}
