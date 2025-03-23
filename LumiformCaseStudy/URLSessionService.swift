//
//  URLSessionService.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import Foundation

enum ServiceResult {
	case success(Data, HTTPURLResponse)
	case failure(Error)
}

protocol ServiceProtocol {
	func fetchData(completion: @escaping (ServiceResult) -> Void)
}
