//
//  SectionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class SectionViewModel: GenericItemViewModel {
	let section: Section
	let nestingLevel: Int
	var type: String { return "section" }
	var items: [GenericItemViewModel] = []
	
	init(section: Section, nestingLevel: Int) {
		self.section = section
		self.nestingLevel = nestingLevel
		setupItems()
	}
	
	private func setupItems() {
		for item in section.items {
			if let section = item.asSection {
				items.append(SectionViewModel(section: section, nestingLevel: nestingLevel + 1))
			} else if let textQuestion = item.asTextQuestion {
				items.append(TextQuestionViewModel(question: textQuestion, nestingLevel: nestingLevel + 1))
			} else if let imageQuestion = item.asImageQuestion {
				items.append(ImageQuestionViewModel(imageService: NetworkImageService(),
													question: imageQuestion,
													nestingLevel: nestingLevel + 1))
			}
		}
	}
}
