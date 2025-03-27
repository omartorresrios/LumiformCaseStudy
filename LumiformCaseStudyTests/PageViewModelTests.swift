//
//  PageViewModelTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/24/25.
//

import XCTest
@testable import LumiformCaseStudy

final class PageViewModelTests: XCTestCase {
	
	func testInitialStateIsIdle() {
		let sut = makeSut()
		XCTAssertEqual(sut.currentState, .idle)
	}
	
	private func makeSut() -> PageViewModel  {
		let mockServiceFactory = MockServiceFactory()
		let viewModel = PageViewModel(page: Page(type: "page",
												 title: "Main page",
												 items: []),
									  serviceFactory: mockServiceFactory)
		return viewModel
	}
	
	final class MockNetworkImageService: ImageService {
		func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
			
		}
	}
	
	final class MockServiceFactory: ServiceFactory {
		var imageService: ImageService
		
		init(imageService: ImageService = MockNetworkImageService()) {
			self.imageService = imageService
		}
		
		func createNetworkImageService() -> ImageService {
			return imageService
		}
		
		func createPageControllers(from pages: [Page], coordinator: PageCoordinatorProtocol) -> [PageViewController] {
			return []
		}
	}
}
