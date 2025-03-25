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
	
	func testSuccessfulFetch() {
		let (sut, mockRepository) = makeSut()
		var capturedStates: [PageViewModel.ViewState] = []
		
		sut.stateChanged = { state in
			capturedStates.append(state)
		}
		
		let textQuestion = TextQuestion(type: "text", title: "Text question title")
		let section = Section(type: "section", title: "Section title", items: [])
		let mockPage = Page(type: "page",
							title: "Page title",
							items: [GenericItem(section), GenericItem(textQuestion)])
		
		mockRepository.fetchItemClosure = { completion in
			completion(.success(GenericItem(mockPage)))
		}
		
		sut.fetchItems()
		
		XCTAssertEqual(capturedStates.count, 2)
		XCTAssertEqual(capturedStates[0], .loading)
		
		guard case .loaded(let viewModels) = capturedStates[1] else {
			XCTFail("Expected loaded state")
			return
		}
		
		XCTAssertEqual(viewModels.count, 2)
		XCTAssertTrue(viewModels[0] is SectionViewModel)
		XCTAssertTrue(viewModels[1] is TextQuestionViewModel)
	}
	
	func testErrorFetch() {
		let (sut, mockRepository) = makeSut()
		var capturedStates: [PageViewModel.ViewState] = []
		
		sut.stateChanged = { state in
			capturedStates.append(state)
		}
		
		mockRepository.fetchItemClosure = { completion in
			completion(.failure(.connectivity))
		}
		
		sut.fetchItems()
		
		XCTAssertEqual(capturedStates.count, 2)
		XCTAssertEqual(capturedStates[0], .loading)
		
		guard case .error(let error) = capturedStates[1] else {
			XCTFail("Expected error state")
			return
		}
		
		XCTAssertTrue(error is NetworkError)
	}
	
	func testEmptyItemsList() {
		let (sut, mockRepository) = makeSut()
		let mockPage = Page(type: "page", title: "Empty Page", items: [])
		
		mockRepository.fetchItemClosure = { completion in
			completion(.success(GenericItem(mockPage)))
		}
		
		sut.fetchItems()
		
		XCTAssertTrue(sut.items.isEmpty)
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
