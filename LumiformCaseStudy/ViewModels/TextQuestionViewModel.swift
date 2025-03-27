//
//  TextQuestionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class TextQuestionViewModel: GenericItemViewModel {
	private let question: TextQuestion
	private let _nestingLevel: Int
	var type: String { return "text" }
	
	var questionTitle: String {
		question.title
	}
	
	var nestingLevel: Int {
		_nestingLevel
	}
	
	init(question: TextQuestion, nestingLevel: Int = 0) {
		self.question = question
		self._nestingLevel = nestingLevel
	}
}
