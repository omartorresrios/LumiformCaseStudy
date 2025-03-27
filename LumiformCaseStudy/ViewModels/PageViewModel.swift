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
	private let page: Page
	private let imageService: ImageService
	private var _title: String
	var items = [GenericItemViewModel]()
	var type: String { return "page" }
	
	var title: String {
		_title
	}
	
	init(page: Page, imageService: ImageService) {
		self.page = page
		self.imageService = imageService
		self._title = page.title
	}
	
	func fetchItems() {
		items = transformToViewModels(page)
	}
	
	private func transformToViewModels(_ page: Page) -> [GenericItemViewModel] {
		var viewModels: [GenericItemViewModel] = []
		
		for item in page.items {
			if let section = item.asSection {
				viewModels.append(SectionViewModel(section: section, nestingLevel: 0))
			} else if let textQuestion = item.asTextQuestion {
				viewModels.append(TextQuestionViewModel(question: textQuestion))
			} else if let imageQuestion = item.asImageQuestion {
				viewModels.append(ImageQuestionViewModel(imageService: imageService,
														 question: imageQuestion))
			}
		}
		
		return viewModels
	}
	
	func flattenedItems() -> [GenericItemViewModel] {
		var result: [GenericItemViewModel] = []
		
		for item in items {
			result.append(item)
			
			if let sectionViewModel = item as? SectionViewModel {
				result.append(contentsOf: flattenItems(for: sectionViewModel))
			}
		}
		
		return result
	}
	
	private func flattenItems(for sectionViewModel: SectionViewModel) -> [GenericItemViewModel] {
		var result: [GenericItemViewModel] = []
		
		for item in sectionViewModel.items {
			result.append(item)
			
			if let nestedSection = item as? SectionViewModel {
				result.append(contentsOf: flattenItems(for: nestedSection))
			}
		}
		
		return result
	}
}
