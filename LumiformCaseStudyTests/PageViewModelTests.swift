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
	
	func testFetchItemsWithTheirRightTypes() {
		let section = Section(type: "section", title: "Section title", items: [])
		let textQuestion = TextQuestion(type: "text", title: "Text question title")
		let imageQuestion = ImageQuestion(type: "image", title: "Image question title", src: "url")
		let page = Page(type: "page", title: "Page title", items: [GenericItem(section),
																   GenericItem(textQuestion),
																   GenericItem(imageQuestion)])
		let sut = makeSut(page: page)
		
		sut.fetchItems()
		
		XCTAssertEqual(sut.items.count, 3)
		XCTAssertTrue(sut.items[0] is SectionViewModel)
		XCTAssertTrue(sut.items[1] is TextQuestionViewModel)
		XCTAssertTrue(sut.items[2] is ImageQuestionViewModel)
	}
	
	func testFetchItemsWithEmptyPage() {
		let sut = makeSut()
		
		sut.fetchItems()
		
		XCTAssertTrue(sut.items.isEmpty)
	}
	
	func testTransformToViewModelsUsesImageService() {
		let imageQuestion = ImageQuestion(type: "image", title: "Image question title", src: "url")
		let page = Page(type: "page", title: "Page title", items: [GenericItem(imageQuestion)])
		let sut = makeSut(page: page)
		
		sut.fetchItems()
		
		let items = sut.items
		XCTAssertEqual(items.count, 1)
		XCTAssertTrue(items[0] is ImageQuestionViewModel)
	}
	
	static let defaultPage = Page(type: "page", title: "Main page", items: [])
	
	private func makeSut(page: Page = PageViewModelTests.defaultPage) -> PageViewModel  {
		let mockImageService = MockNetworkImageService()
		let viewModel = PageViewModel(page: page, imageService: mockImageService)
		return viewModel
	}
	
	final class MockNetworkImageService: ImageService {
		func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
			
		}
	}
}
