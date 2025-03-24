//
//  PageViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import Foundation

protocol GenericItemViewModel {
	var type: String { get }
}

final class PageViewModel: GenericItemViewModel {
	let page: Page
	var items: [GenericItemViewModel] = []
	var type: String { return "page" }
	
	init(page: Page) {
		self.page = page
		setupItems()
	}
	
	private func setupItems() {
		for item in page.items {
			if let nestedPage = item.asPage {
				let nestedPageViewModel = PageViewModel(page: nestedPage)
				items.append(nestedPageViewModel)
			} else if let section = item.asSection {
				items.append(SectionViewModel(section: section, nestingLevel: 0))
			} else if let textQuestion = item.asTextQuestion {
				items.append(TextQuestionViewModel(question: textQuestion))
			} else if let imageQuestion = item.asImageQuestion {
				items.append(ImageQuestionViewModel(question: imageQuestion))
			}
		}
	}
}
