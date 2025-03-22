//
//  ModelTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/22/25.
//

import XCTest

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
}
