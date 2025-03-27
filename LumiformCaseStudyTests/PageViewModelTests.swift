//
//  PageViewModelTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/24/25.
//

import XCTest
@testable import LumiformCaseStudy

final class PageViewModelTests: XCTestCase {
	
	func testTypeReturnsPage() {
		let sut = makeSut()
		XCTAssertEqual(sut.type, "page")
	}
	
	func testTitleReturnsPageTitle() {
		let sut = makeSut()
		XCTAssertEqual(sut.title, "Main page")
	}
	
	func testItemsIsInitiallyEmpty() {
		let sut = makeSut()
		XCTAssertTrue(sut.items.isEmpty)
	}
	
	private func makeSut() -> PageViewModel  {
		let mockImageService = MockNetworkImageService()
		let viewModel = PageViewModel(page: Page(type: "page",
												 title: "Main page",
												 items: []),
									  imageService: mockImageService)
		return viewModel
	}
	
	final class MockNetworkImageService: ImageService {
		func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
			
		}
	}
}
