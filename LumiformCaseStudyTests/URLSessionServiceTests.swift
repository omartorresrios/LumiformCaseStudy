//
//  URLSessionServiceTests.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/27/25.
//

import XCTest
@testable import LumiformCaseStudy

final class URLSessionServiceTests: XCTestCase {
	
	var sut: URLSessionService!
		
	override func setUp() {
		super.setUp()
		sut = URLSessionService()
		URLProtocol.registerClass(MockURLProtocol.self)
		MockURLProtocol.requestHandler = nil
	}
	
	override func tearDown() {
		sut = nil
		URLProtocol.unregisterClass(MockURLProtocol.self)
		MockURLProtocol.requestHandler = nil
		super.tearDown()
	}

	func testFetchDataSuccess() {
		let testData = "Test Data".data(using: .utf8)!
		let testResponse = HTTPURLResponse(url: URL(string: "https://run.mocky.io/v3/1800b96f-c579-49e5-b0b8-49856a36ce39")!,
										   statusCode: 200,
										   httpVersion: nil,
										   headerFields: nil)!
		
		MockURLProtocol.requestHandler = { request in
			return (testResponse, testData)
		}
		
		var result: ServiceResult?
		let expectation = self.expectation(description: "Completion called with success")
		
		sut.fetchData { serviceResult in
			result = serviceResult
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { _ in
			if case .success(let data, let response) = result {
				XCTAssertEqual(data, testData)
				XCTAssertEqual(response.statusCode, 200)
			} else {
				XCTFail("Expected success result")
			}
		}
	}
	
	func testFetchDataFailure() {
		let testError = NSError(domain: "Test", code: -1, userInfo: nil)
		let testURL = URL(string: "https://run.mocky.io/v3/1800b96f-c579-49e5-b0b8-49856a36ce39")!
		
		MockURLProtocol.requestHandler = { request in
			XCTAssertEqual(request.url, testURL, "Request URL should match the service's URL")
			throw testError
		}
		
		var result: ServiceResult?
		let expectation = self.expectation(description: "Completion called with failure")
		
		sut.fetchData { serviceResult in
			result = serviceResult
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { error in
			if let error = error {
				XCTFail("Expectation failed with error: \(error)")
				return
			}
			guard case .failure(let error) = result else {
				XCTFail("Expected failure result, got \(String(describing: result))")
				return
			}
			XCTAssertEqual((error as NSError).code, testError.code, "Error code should match")
		}
	}
	
	final class MockURLProtocol: URLProtocol {
		static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
		
		override class func canInit(with request: URLRequest) -> Bool {
			// Handle all requests
			return true
		}
		
		override class func canonicalRequest(for request: URLRequest) -> URLRequest {
			return request
		}
		
		override func startLoading() {
			guard let handler = MockURLProtocol.requestHandler else {
				XCTFail("Request handler not set")
				return
			}
			
			do {
				let (response, data) = try handler(request)
				client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
				client?.urlProtocol(self, didLoad: data)
				client?.urlProtocolDidFinishLoading(self)
			} catch {
				client?.urlProtocol(self, didFailWithError: error)
			}
		}
		
		override func stopLoading() {
			// No-op for this simple mock
		}
	}
}
