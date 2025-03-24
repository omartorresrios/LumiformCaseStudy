//
//  PageViewModelTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/24/25.
//

import XCTest
@testable import LumiformCaseStudy

final class PageViewModelTests: XCTestCase {
	
	func testInitialState() {
		let (sut, _) = makeSut()
		XCTAssertEqual(sut.type, "page")
		XCTAssertTrue(sut.items.isEmpty)
	}
	
	func testFetchItemsLoading() {
		let (sut, mockRepository) = makeSut()
		var capturedStates: [PageViewModel.ViewState] = []
		
		sut.stateChanged = { state in
			capturedStates.append(state)
		}
		
		mockRepository.fetchItemClosure = { _ in }
		
		sut.fetchItems()
		
		XCTAssertEqual(capturedStates.first, .loading)
	}

	private func makeSut() -> (PageViewModel, MockItemRepository)  {
		let mockRepository = MockItemRepository()
		let viewModel = PageViewModel(repository: mockRepository)
		return (viewModel, mockRepository)
	}
}

final class MockItemRepository: GenericItemRepositoryProtocol {
	var fetchItemClosure: (((@escaping (FetchDataResult) -> Void)) -> Void)?
	
	func fetchItem(completion: @escaping (FetchDataResult) -> Void) {
		fetchItemClosure?(completion)
	}
}
