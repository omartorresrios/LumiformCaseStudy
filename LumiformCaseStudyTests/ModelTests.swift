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
}
