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
		let sut = makeSut()
		var initialState: RootPageViewModel.ViewState?
		sut.stateDidChange = { state in
			initialState = state
		}
		XCTAssertNil(initialState, "No state change should occur on init")
	}
	
	private func makeSut() -> RootPageViewModel  {
		let repository = MockRepository()
		let viewModel = RootPageViewModel(repository: repository)
		return viewModel
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

