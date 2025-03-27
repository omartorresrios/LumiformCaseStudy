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

