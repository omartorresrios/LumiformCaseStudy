//
//  SectionViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

final class SectionViewModel: GenericItemViewModel {
	private let section: Section
	private let _nestingLevel: Int
	private var _items: [GenericItemViewModel] = []
	var type: String { return "section" }
	
	var title: String {
		return section.title
	}
	
	var nestingLevel: Int {
		_nestingLevel
	}
	
	var items: [GenericItemViewModel] {
		_items
	}
	
	init(section: Section, nestingLevel: Int) {
		self.section = section
		self._nestingLevel = nestingLevel
		setupItems()
	}
	
	private func setupItems() {
		for item in section.items {
			if let section = item.asSection {
				_items.append(SectionViewModel(section: section, nestingLevel: nestingLevel + 1))
			} else if let textQuestion = item.asTextQuestion {
				_items.append(TextQuestionViewModel(question: textQuestion, nestingLevel: nestingLevel + 1))
			} else if let imageQuestion = item.asImageQuestion {
				_items.append(ImageQuestionViewModel(imageService: NetworkImageService(),
													question: imageQuestion,
													nestingLevel: nestingLevel + 1))
			}
		}
	}
}
