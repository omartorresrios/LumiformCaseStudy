//
//  ModelTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/22/25.
//

import XCTest
@testable import LumiformCaseStudy

final class ModelTests: XCTestCase {
	
	var testData: Data!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		guard let path = Bundle(for: type(of: self)).path(forResource: "testdata", ofType: "json") else {
			XCTFail("Failed to find test data file")
			return
		}
		testData = try Data(contentsOf: URL(fileURLWithPath: path))
	}
	
	func testDecodeRootStructure() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			XCTAssertNotNil(rootItem.asPage, "Root item should be a Page")
			
			if let page = rootItem.asPage {
				XCTAssertEqual(page.type, "page")
				XCTAssertEqual(page.title, "Main Page")
				XCTAssertEqual(page.items.count, 3)
			}
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testPageStructure() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			guard let page = rootItem.asPage else {
				XCTFail("Root should be a Page")
				return
			}
			
			XCTAssertNotNil(page.items[0].asSection)
			
			if let firstSection = page.items[0].asSection {
				XCTAssertEqual(firstSection.title, "Introduction")
			}
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testSectionContents() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			guard let page = rootItem.asPage,
				  let firstSection = page.items[0].asSection else {
				XCTFail("Failed to find first section")
				return
			}
			
			XCTAssertEqual(firstSection.type, "section")
			XCTAssertEqual(firstSection.title, "Introduction")
			XCTAssertEqual(firstSection.items.count, 2)
			XCTAssertNotNil(firstSection.items[0].asTextQuestion)
			XCTAssertNotNil(firstSection.items[1].asImageQuestion)
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testNestedSections() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			guard let page = rootItem.asPage,
				  let chapterSection = page.items[1].asSection else {
				XCTFail("Failed to find Chapter 1 section")
				return
			}
			
			XCTAssertEqual(chapterSection.title, "Chapter 1")
			XCTAssertEqual(chapterSection.items.count, 2)
			
			let nestedSection = chapterSection.items[1].asSection
			XCTAssertNotNil(nestedSection, "Second item in Chapter 1 should be a subsection")
			
			if let subsection = nestedSection {
				XCTAssertEqual(subsection.title, "Subsection 1.1")
				XCTAssertEqual(subsection.items.count, 2)
				XCTAssertNotNil(subsection.items[0].asTextQuestion)
				XCTAssertNotNil(subsection.items[1].asImageQuestion)
			}
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testTextQuestions() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			guard let page = rootItem.asPage,
				  let section = page.items[0].asSection,
				  let textQuestion = section.items[0].asTextQuestion else {
				XCTFail("Failed to find text question")
				return
			}
			
			XCTAssertEqual(textQuestion.type, "text")
			XCTAssertEqual(textQuestion.title, "Welcome to the main page!")
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testImageQuestions() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			guard let page = rootItem.asPage,
				  let section = page.items[0].asSection,
				  let imageQuestion = section.items[1].asImageQuestion else {
				XCTFail("Failed to find image question")
				return
			}
			
			XCTAssertEqual(imageQuestion.type, "image")
			XCTAssertEqual(imageQuestion.title, "Welcome Image")
			XCTAssertEqual(imageQuestion.src, "https://robohash.org/280?&set=set4&size=400x400")
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testNestedPages() {
		do {
			let decoder = JSONDecoder()
			let rootItem = try decoder.decode(GenericItem.self, from: testData)
			
			guard let page = rootItem.asPage else {
				XCTFail("Root should be a Page")
				return
			}
			
			let nestedPage = page.items[2].asPage
			XCTAssertNotNil(nestedPage, "Third item should be a nested page")
			
			if let secondPage = nestedPage {
				XCTAssertEqual(secondPage.title, "Second Page")
				XCTAssertEqual(secondPage.items.count, 1)
				
				let nestedSection = secondPage.items[0].asSection
				XCTAssertNotNil(nestedSection)
				XCTAssertEqual(nestedSection?.title, "Chapter 2")
			}
		} catch {
			XCTFail("JSON decoding failed: \(error)")
		}
	}
	
	func testInvalidTypeHandling() {
		let invalidJSON = """
   {
   "type": "invalid_type",
   "title": "Invalid Item"
   }
   """.data(using: .utf8)!
		
		do {
			let decoder = JSONDecoder()
			_ = try decoder.decode(GenericItem.self, from: invalidJSON)
			XCTFail("Decoding should fail with invalid type")
		} catch {
			XCTAssertTrue(error is DecodingError, "Error should be a DecodingError")
		}
	}
	
	func testMissingRequiredFields() {
		let invalidJSON = """
   {
   "type": "text"
   }
   """.data(using: .utf8)!
		
		do {
			let decoder = JSONDecoder()
			_ = try decoder.decode(GenericItem.self, from: invalidJSON)
			XCTFail("Decoding should fail with missing required fields")
		} catch {
			XCTAssertTrue(error is DecodingError, "Error should be a DecodingError")
		}
	}
	
	func testTypeErasureAndRetrieval() {
		let textQuestion = TextQuestion(type: "text", title: "Test Question")
		let section = Section(type: "section", title: "Test Section", items: [])
		
		let anyTextQuestion = GenericItem(textQuestion)
		let anySection = GenericItem(section)
		
		XCTAssertNotNil(anyTextQuestion.asTextQuestion)
		XCTAssertNil(anyTextQuestion.asSection)
		
		XCTAssertNotNil(anySection.asSection)
		XCTAssertNil(anySection.asTextQuestion)
		
		XCTAssertNotNil(anyTextQuestion.get() as TextQuestion?)
		XCTAssertNil(anyTextQuestion.get() as Section?)
	}
}
