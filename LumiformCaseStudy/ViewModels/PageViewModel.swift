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
	enum ViewState {
		case loading
		case loaded([GenericItemViewModel])
	}
	
	private let repository: GenericItemRepositoryProtocol
	var type: String { return "page" }
	var stateChanged: ((ViewState) -> Void)?
	
	private(set) var currentState: ViewState = .loading {
		didSet {
			stateChanged?(currentState)
		}
	}
	
	var items: [GenericItemViewModel] {
		switch currentState {
		case .loaded(let viewModels):
			return viewModels
		case .loading:
			return []
		}
	}
	
	private(set) var title: String = ""
	
	init(repository: GenericItemRepositoryProtocol) {
		self.repository = repository
	}
	
	func fetchItems() {
		repository.fetchItem { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let item):
				if let page = item.asPage {
					self.title = page.title
					let viewModels = self.transformToViewModels(page)
					self.currentState = .loaded(viewModels)
				}
			case .failure(let error):
				break
			}
		}
	}
	
	private func transformToViewModels(_ page: Page) -> [GenericItemViewModel] {
		var viewModels: [GenericItemViewModel] = []
		
		for item in page.items {
			if let nestedPage = item.asPage {
				viewModels.append(contentsOf: transformToViewModels(nestedPage))
			} else if let section = item.asSection {
				viewModels.append(SectionViewModel(section: section, nestingLevel: 0))
			} else if let textQuestion = item.asTextQuestion {
				viewModels.append(TextQuestionViewModel(question: textQuestion))
			} else if let imageQuestion = item.asImageQuestion {
				viewModels.append(ImageQuestionViewModel(question: imageQuestion))
			}
		}
		
		return viewModels
	}
}
