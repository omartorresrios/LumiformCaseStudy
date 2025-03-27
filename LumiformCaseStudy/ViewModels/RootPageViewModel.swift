//
//  RootPageViewModel.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/27/25.
//

import Foundation

final class RootPageViewModel {
	enum ViewState {
		case idle
		case loading
		case loaded([Page])
		case error(NetworkError)
	}
	
	private let repository: GenericItemRepositoryProtocol
	private var state: ViewState = .idle {
		didSet { stateDidChange?(state) }
	}
	var stateDidChange: ((ViewState) -> Void)?

	init(repository: GenericItemRepositoryProtocol) {
		self.repository = repository
	}

	func fetchTopLevelPages() {
		state = .loading
		repository.fetchTopLevelPages { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let pages):
				self.state = .loaded(pages)
			case .failure(let error):
				self.state = .error(error)
			}
		}
	}
}

extension RootPageViewModel.ViewState: Equatable {
	static func == (lhs: RootPageViewModel.ViewState, rhs: RootPageViewModel.ViewState) -> Bool {
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
