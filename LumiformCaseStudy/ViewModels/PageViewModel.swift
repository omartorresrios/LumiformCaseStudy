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
		case idle
		case loading
		case loaded([GenericItemViewModel])
		case error(Error)
	}
	
	private let repository: GenericItemRepositoryProtocol
	var type: String { return "page" }
	var stateChanged: ((ViewState) -> Void)?
	
	private(set) var currentState: ViewState = .idle {
		didSet {
			stateChanged?(currentState)
		}
	}
	
	var items: [GenericItemViewModel] {
		switch currentState {
		case .loaded(let viewModels):
			return viewModels
		default:
			return []
		}
	}
	
	private(set) var title: String = ""
	
	init(repository: GenericItemRepositoryProtocol) {
		self.repository = repository
	}
	
	func fetchItems() {
		currentState = .loading
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
				self.currentState = .error(error)
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

extension PageViewModel.ViewState: Equatable {
	static func == (lhs: PageViewModel.ViewState, rhs: PageViewModel.ViewState) -> Bool {
		switch (lhs, rhs) {
		case (.idle, .idle), (.loading, .loading):
			return true
		case (.loaded(let lhsItems), .loaded(let rhsItems)):
			return lhsItems.map { $0.type } == rhsItems.map { $0.type }
		case (.error(let lhsError), .error(let rhsError)):
			return lhsError.localizedDescription == rhsError.localizedDescription
		default:
			return false
		}
	}
}
