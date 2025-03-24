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
		let sut = makeSut()
		XCTAssertEqual(sut.type, "page")
		XCTAssertTrue(sut.items.isEmpty)
	}

	private func makeSut() -> PageViewModel {
		let mockRepository = MockItemRepository()
		let viewModel = PageViewModel(repository: mockRepository)
		return viewModel
	}
}

final class MockItemRepository: GenericItemRepositoryProtocol {
	var fetchItemClosure: (((@escaping (FetchDataResult) -> Void)) -> Void)?
	
	func fetchItem(completion: @escaping (FetchDataResult) -> Void) {
		fetchItemClosure?(completion)
	}
}
