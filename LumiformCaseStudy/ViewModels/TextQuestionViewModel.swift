//
//  TextQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class TextQuestionViewModel: GenericItemViewModel {
	let question: TextQuestion
	var type: String { return "text" }
	
	init(question: TextQuestion) {
		self.question = question
	}
}
