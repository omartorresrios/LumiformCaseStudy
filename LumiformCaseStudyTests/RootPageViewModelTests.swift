//
//  RootPageViewModelTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/27/25.
//

import XCTest
@testable import LumiformCaseStudy

final class RootPageViewModelTests: XCTestCase {
	
	func testInitialStateIsIdle() {
		let (sut, _) = makeSut()
		var initialState: RootPageViewModel.ViewState?
		sut.stateDidChange = { state in
			initialState = state
		}
		XCTAssertNil(initialState, "No state change should occur on init")
	}
	
	func testFetchTopLevelPagesTransitionsToLoading() {
		let (sut, mockRepository) = makeSut()
		var states: [RootPageViewModel.ViewState] = []
		sut.stateDidChange = { state in
			states.append(state)
		}
		mockRepository.fetchPagesResult = .success([])
		
		sut.fetchTopLevelPages()
		
		XCTAssertEqual(states.first, .loading)
	}
	
	func testFetchTopLevelPagesSuccess() {
		let (sut, mockRepository) = makeSut()
		var states: [RootPageViewModel.ViewState] = []
		let expectation = self.expectation(description: "State changes to loaded")
		sut.stateDidChange = { state in
			states.append(state)
			if case .loaded = state {
				expectation.fulfill()
			}
		}
		let testPages = [TestHelper.mockPage1(), TestHelper.mockPage2()]
		mockRepository.fetchPagesResult = .success(testPages)
		
		sut.fetchTopLevelPages()
		
		waitForExpectations(timeout: 1.0) { _ in
			XCTAssertEqual(states.count, 2)
			XCTAssertEqual(states[0], .loading)
			if case .loaded(let pages) = states[1] {
				XCTAssertEqual(pages.count, 2)
				XCTAssertEqual(pages[0].title, TestHelper.mockPage1().title)
				XCTAssertEqual(pages[1].title, TestHelper.mockPage2().title)
			} else {
				XCTFail("Expected loaded state")
			}
		}
	}
	
	func testFetchTopLevelPagesFailure() {
		let (sut, mockRepository) = makeSut()
		var states: [RootPageViewModel.ViewState] = []
		let expectation = self.expectation(description: "State changes to error")
		sut.stateDidChange = { state in
			states.append(state)
			if case .error = state {
				expectation.fulfill()
			}
		}
		let testError = NetworkError.invalidData
		mockRepository.fetchPagesResult = .failure(testError)
		
		sut.fetchTopLevelPages()
		
		waitForExpectations(timeout: 1.0) { _ in
			XCTAssertEqual(states.count, 2)
			XCTAssertEqual(states[0], .loading)
			if case .error(let error) = states[1] {
				XCTAssertEqual(error, testError)
			} else {
				XCTFail("Expected error state")
			}
		}
	}

	private func makeSut() -> (RootPageViewModel, MockRepository) {
		let repository = MockRepository()
		let viewModel = RootPageViewModel(repository: repository)
		return (viewModel, repository)
	}
	
	final class MockRepository: GenericItemRepositoryProtocol {
		var fetchPagesResult: FetchPagesResult?
		
		func fetchTopLevelPages(completion: @escaping (FetchPagesResult) -> Void) {
			if let result = fetchPagesResult {
				completion(result)
			}
		}
	}
}

